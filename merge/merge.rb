# encoding: utf-8


require 'sportdb/text'     ## csv (text) support



class CsvMatchUpdates

  attr_reader :errors, :count

  def initialize( path )
    @pack    = CsvPackage.new( path )
    @matches = {}   # cached match lists / datafiles

    @errors  = []
    @count   = 0
  end

  def reset
    @errors = []
    @count  = 0     ## checked matches
  end


  def find_by_season_n_division( season, division_key )
    @entries ||= @pack.find_entries_by_season_n_division

    season_key = SeasonUtils.key( season )   ## unify season key e.g. 2013-2014 => 2013/14
    entry = @entries[ season_key ][ division_key ]
    path  = @pack.expand_path( entry )

    ## note: store matches with division first and than season - why? why not?
    matches = @matches[ division_key ] ||= {}
    matches[ season_key ] ||= CsvMatchReader.read( path )
  end

  def write
    ## write back (cached) match changes / updates
    @matches.each do |division_key,seasons|
      seasons.each do |season_key,matches|
        entry = @entries[ season_key ][ division_key ]
        path  = @pack.expand_path( entry )
        CsvMatchWriter.write( path, matches )
      end
    end
  end


  ## read control datafile for (double) checking / syncing / updating
  def read( path, headers, start: nil, level: nil, sep: ',' )
    ## start parameter for start with season (skip older seasons)
    i = 0
    level = [level]   if level && level.is_a?(Integer)  ## always us an array for levels

    CSV.foreach( path, headers: true, col_sep: sep ) do |row|
      i += 1
      print '.' if i % 100 == 0
      ## break if i == 10

      h={}
      headers.each do |k,v|
        h[k]=row[v]
      end

      ## check if start season level present
      ##   fix: make start_year work for single-year season too!!!
      ##    crashes with undefined method `tr' for nil:NilClass (NoMethodError)
      ## next  if start && SeasonUtils.start_year( h[:season] ) < SeasonUtils.start_year( start )
      ##    check if start_year returns a string or integer?
      next  if start && h[:season] < SeasonUtils.start_year( start )
      next  if level && level.include?( h[:level].to_i ) == false

      yield( h )  if block_given?
    end
    puts " #{i} rows"   #=> 15_548 rows
  end



##
def build_match( h )
  ## todo/check:  warn if team not known/found - why? why not?
  team_mappings = SportDb::Import.config.team_mappings
  team1 = h[:team1]
  team2 = h[:team2]
  team1 = team_mappings[ team1 ]   if team_mappings[ team1 ]
  team2 = team_mappings[ team2 ]   if team_mappings[ team2 ]


  col = h[ :date ]
  col = col.strip   # make sure not leading or trailing spaces left over

  if col.empty? || col == '-' || col == '?'
     ## note: allow missing / unknown date for match
     date = nil
  else
    if col =~ /^\d{4}-\d{2}-\d{2}$/      ## "standard" / default date format
      date_fmt = '%Y-%m-%d'   # e.g. 1995-08-04
    elsif col =~ /^\d{1,2} \w{3} \d{4}$/
      date_fmt = '%d %b %Y'   # e.g. 8 Jul 2017
    else
      puts "*** !!! wrong (unknown) date format >>#{col}<<; cannot continue; fix it; sorry"
      ## todo/fix: add to errors/warns list - why? why not?
      exit 1
    end

    ## todo/check: use date object (keep string?) - why? why not?
    ##  todo/fix: yes!! use date object!!!! do NOT use string
    date = Date.strptime( col, date_fmt ).strftime( '%Y-%m-%d' )
  end

  round   = nil
  ## check for (optional) round / matchday
  if h[ :round ]
    col = h[ :round ]
    ## todo: issue warning if not ? or - (and just empty string) why? why not
    round = col.to_i  if col =~ /^\d{1,2}$/     # check format - e.g. ignore ? or - or such non-numbers for now
  end

  score1  = nil
  score2  = nil
  score1i = nil
  score2i = nil

  ## check for all-in-one full time scores?
  if h[ :score ]
    ft = h[ :score ]
    if ft =~ /^\d{1,2}[\-:]\d{1,2}$/   ## sanity check scores format
      scores = ft.split( /[\-:]/ )
      score1 = scores[0].to_i
      score2 = scores[1].to_i
    end
    ## todo/fix: issue warning if non-empty!!! and not matching format!!!!
  end

  if h[ :scorei ]
    ht = h[ :scorei ]
    if ht =~ /^\d{1,2}[\-:]\d{1,2}$/   ## sanity check scores format
      scores = ht.split( /[\-:]/)   ## allow 1-1 and 1:1
      score1i = scores[0].to_i
      score2i = scores[1].to_i
    end
    ## todo/fix: issue warning if non-empty!!! and not matching format!!!!
  end

  match = SportDb::Struct::Match.new( date:  date,
                                        team1: team1,     team2: team2,
                                        score1: score1,   score2: score2,
                                        score1i: score1i, score2i: score2i,
                                        round:  round )
  match
end


def cmp_match( l, r )
   ## compare date and scores
    if l.date != r.date
      pp l
      pp r
      puts "date mismatch!!  #{l.date} != #{r.date}"
      @errors << "date mismatch - is >#{l.date}< expected >#{r.date}< | #{r.team1} vs #{r.team2}"
      ## todo - fix - add to warn log!!!!
      ## todo - fix date - why? why not?
      ## return false
    end
    if l.score1 != r.score1 ||
       l.score2 != r.score2
      puts "score mismatch!!"
      return false
    end
    if l.score1i != r.score1i ||
       l.score2i != r.score2i

       if l.score1i.nil? && l.score2i.nil?
         ## skip - has no half time (ht) score
       elsif r.score1i.nil? && r.score2i.nil?
         puts "(auto-)update half-time score (score1i/score2i)"
          r.update( score1i: l.score1i,
                    score2i: l.score2i )
       else
         pp l
         pp r
         puts "scorei (ht) mismatch!!  #{l.score1i}-#{l.score2i}  != #{r.score1i}-#{r.score2i}"
         @errors << "scorei (ht) mismatch - is >#{l.score1i}-#{l.score2i}< expected >#{r.score1i}-#{r.score2i}< | #{r.date} #{r.team1} vs #{r.team2}"
         ## todo - fix - add to warn log!!!!
         ## todo - fix halftime score - why? why not?
         ## return false
       end
    end
    return true
end


def find_match( matches, match )
  team1 = match.team1
  team2 = match.team2

  matches.select { |m| m.team1 == team1 && m.team2 == team2 }
end




def on_find_match( matches, h )

  match = build_match( h )

  res = find_match( matches, match )
  if res.size == 0
    puts "!!! no matching match found"
    exit 1
  elsif res.size == 1
    yield( match, res.first )
  else
    puts "warn: more than one match found - #{res.size} - CANNOT auto-update"
    pp res
    exit 1
  end
end  # method on_find_match



#############
#  main entry points

def update_round( path, headers, start: nil, level: nil, sep: ',' )
  reset
  read( path, headers, start: start, level: level, sep: sep ) do |h|
    yield( h )  if block_given?
    _update_round( h )
  end
  ## note: return count of records - why? why not?
  count
end

def _update_round( h )
  season   = h.delete( :season )
  division = h.delete( :division )
  matches = find_by_season_n_division( season, division )
  on_find_match( matches, h ) do |l,r|
    if cmp_match( l, r )
      r.update( round: l.round )   ## auto-update round !!
      puts "updating round #{l.round} - #{r.date} #{r.team1} vs #{r.team2}"
    else
      puts "warn: (fatal) match mismatch!!! check diff"
      exit 1
    end
  end
end


def check( path, headers, start: nil, level: nil, sep: ',' )
  reset
  read( path, headers, start: start, level: level, sep: sep ) do |h|
    yield( h )  if block_given?
    _check( h )
  end
  ## note: return count of records - why? why not?
  count
end

def _check( h )
  season   = h.delete( :season )
  division = h.delete( :division )
  matches = find_by_season_n_division( season, division )
  on_find_match( matches, h ) do |l,r|
    ## note: l-left is the new record
    ##       r-right is the original (base) record
    @count += 1
    if cmp_match( l, r )
      ## do nothing
    else
      puts "warn: (fatal) match mismatch!!! check diff"
      exit 1
    end
  end
end

end  # CsvMatchUpdates
