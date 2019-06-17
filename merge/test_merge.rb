# encoding: utf-8


require 'sportdb/text'     ## csv (text) support



module SeasonHelper ## use Helpers why? why not?
  def key( basename )
    ## todo: add 1964-1965 format too!!!
    if basename =~ /^(\d{4})[\-\/](\d{2})$/    ## season format is  1964-65
      "#{$1}/#{$2}"
    elsif  basename =~ /^(\d{4})[\-\/](\d{4})$/   ## e.g. 2011-2012 or 2011/2012 => 2011-12
      "%4d/%02d" % [$1.to_i, $2.to_i % 100]
    elsif basename =~ /^(\d{4})$/
      $1
    else
      puts "*** !!!! wrong season format >>#{basename}<<; exit; sorry"
      exit 1
    end
  end  # method key
end






## all bundesliga seasons in a single .csv file e.g.
##    Bundesliga_1963_2014.csv
##  assumes the following fields/header
##  - Spielzeit;Saison;Spieltag;Datum;Uhrzeit;Heim;Gast;Ergebnis;Halbzeit
##  e.g.
## 1;1963-1964;1;1963-08-24;17:00;Werder Bremen;Borussia Dortmund;3:2;1:1
## 1;1963-1964;1;1963-08-24;17:00;1. FC Saarbruecken;1. FC Koeln;0:2;0:2

#
# note: separator is semi-colon (e.g. ;)



## start parameter for start with season (skip older seasons)
def read( path, headers, start: nil, level: nil, col_sep: ',' )
  i = 0
  level = [level]   if level && level.is_a?(Integer)  ## always us an array for levels

  CSV.foreach( path, headers: true, col_sep: col_sep ) do |row|
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

    yield(h) if block_given?
  end
  puts " #{i} rows"   #=> 15_548 rows
end



class CsvMatchUpdates

  attr_reader :errors, :count

  def initialize( path, format: 'short' )  # short | long
    @path    = path       ## root package path
    @format  = format
    @matches = {}   # cached match lists / datafiles

    @errors  = []
    @count   = 0
  end

  def reset
    @errors = []
    @count  = 0     ## checked matches
  end


  def find_by_season( season, basename )
    ## todo/fix: use CsvPackage and lookup by season and Level
    ##  check england  and find a way to deal with for more than one datafile per level!!!

    season_key = SeasonUtils.key( season )   ## unify season key e.g. 2013-2014 => 2013/14
    path = "#{@path}/#{SeasonUtils.directory( season_key, format: @format)}/#{basename}.csv"
    matches = @matches[ basename ] ||= {}
    matches[ season_key ] ||= CsvMatchReader.read( path )
  end

  def write
    ## write back changes
    @matches.each do |basename,seasons|
      seasons.each do |season_key,matches|
        path = "#{@path}/#{SeasonUtils.directory( season_key, format: @format)}/#{basename}.csv"
        CsvMatchWriter.write( path, matches )
      end
    end
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





def update_round( h )
  season = h.delete( :season )
  basename = h.delete( :basename )   ## e.g. '1-bundesliga'
  matches = find_by_season( season, basename )
  on_find_match( matches, h ) do |l,r|
    if cmp_match( l, r )
      r.update( round: l.round )   ## auto-update round !!
      puts "updating round #{l.round} - #{r.date} #{r.team1} vs #{r.team2}"
    else
      puts "warn: match mismatch!!! check diff"
      exit 1
    end
  end
end

def check( h )
  season = h.delete( :season )
  basename = h.delete( :basename )   ## e.g. '1-bundesliga'
  matches = find_by_season( season, basename )
  on_find_match( matches, h ) do |l,r|
    ## note: l-left is the new record
    ##       r-right is the original (base) record
    @count += 1
    if cmp_match( l, r )
      ## do nothing
    else
      puts "warn: match mismatch!!! check diff"
      exit 1
    end
  end
end

end  # CsvMatchUpdates


## "","Date","Season","home","visitor","FT","hgoal","vgoal","division","tier","totgoal","goaldif","result"
#{# }"1",1888-12-15,1888,"Accrington F.C.","Aston Villa","1-1",1,1,"1",1,2,0,"D"


ENG = CsvMatchUpdates.new( '../eng-england', format: 'long' )
## pp ENG.find_by_season( '2013-2014', '1-premierleague' )

in_path = './dl/engsoccerdata/data-raw/england.csv'

headers = {
    team1:  'home',
    team2:  'visitor',
    date:   'Date',
    score:  'FT',
    season: 'Season',
    level:  'tier'
    }


## 1993-94
ENG.reset
read( in_path, headers, start: '2004-05', level: 1 ) do |h|
  h[:basename] = '1-premierleague'   ## add (required/expected) basename in hash too
  h[:season]   = "%4d-%02d" % [h[:season].to_i, (h[:season].to_i+1) % 100]    ## fix season
  ENG.check( h )
end
pp ENG.errors
pp ENG.count




__END__

DE = CsvMatchUpdates.new( '../de-deutschland', format: 'long' )
## pp DE.find_by_season( '2013-2014', '1-bundesliga' )


in_path = './dl/Bundesliga_1963_2014.csv'

headers = {
    team1:  'Heim',
    team2:  'Gast',
    date:   'Datum',
    score:  'Ergebnis',
    scorei: 'Halbzeit',
    round:  'Spieltag',
    season: 'Saison',
    }


## 1993-94
DE.reset
read( in_path, headers, start: '1993-94', col_sep: ';' ) do |h|
  h[:basename] = '1-bundesliga'   ## add (required/expected) basename in hash too
  ## DE.update_round( h )
  DE.check( h )
end
pp DE.errors
pp DE.count

## DE.write    ## write back all changes
