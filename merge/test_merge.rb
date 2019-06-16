# encoding: utf-8


require 'sportdb/text'     ## csv (text) support

## all bundesliga seasons in a single .csv file e.g.
##    Bundesliga_1963_2014.csv
##  assumes the following fields/header
##  - Spielzeit;Saison;Spieltag;Datum;Uhrzeit;Heim;Gast;Ergebnis;Halbzeit
##  e.g.
## 1;1963-1964;1;1963-08-24;17:00;Werder Bremen;Borussia Dortmund;3:2;1:1
## 1;1963-1964;1;1963-08-24;17:00;1. FC Saarbruecken;1. FC Koeln;0:2;0:2

#
# note: separator is semi-colon (e.g. ;)

in_path = './dl/Bundesliga_2014.csv'

## try a dry test run
  i = 0
  CSV.foreach( in_path, headers: true, col_sep: ';' ) do |row|
    i += 1
    print '.' if i % 100 == 0
  end
  puts " #{i} rows"   #=> 15_548 rows


## todo/add - start parameter for start with season (skip older seasons)
def read( path, headers )
  i = 0
  CSV.foreach( path, headers: true, col_sep: ';' ) do |row|
    i += 1
    ## break if i == 10

    h={}
    headers.each do |k,v|
      h[k]=row[v]
    end
    yield(h) if block_given?
  end
  puts " #{i} rows"   #=> 15_548 rows
end


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


##
# 2013-2014
de_2013_14_path = '../de-deutschland/2010s/2013-14/1-bundesliga.csv'
MATCHES = {}
MATCHES['2013-14'] = CsvMatchReader.read( de_2013_14_path )
pp MATCHES


def cmp_match( l, r )
   ## compare date and scores
    if l.date != r.date
      puts "date mismatch!!"
      return false
    end
    if l.score1 != r.score1 ||
       l.score2 != r.score2
      puts "score mismatch!!"
      return false
    end
    if l.score1i != r.score1i ||
       l.score2i != r.score2i
      puts "scorei mismatch!!"
      return false
    end
    return true
end


def find_match( matches, match )
  team1 = match.team1
  team2 = match.team2

  matches.select { |m| m.team1 == team1 && m.team2 == team2 }
end



def update_match( h, season:, level: 1 )

  match = build_match( h )
  pp match

  res = find_match( MATCHES['2013-14'], match )
  if res.size == 0
    puts "!!! no matching match found"
    exit 1
  elsif res.size == 1
    if cmp_match( match, res.first )
      res.first.update( round: match.round )   ## auto-update round !!
      pp res.first
    else
      puts "warn: match mismatch!!! check diff"
      exit 1
    end
  else
    puts "warn: more than one match found - #{res.size} - CANNOT auto-update"
    pp res
    exit 1
  end
end




headers = {
    team1:  'Heim',
    team2:  'Gast',
    date:   'Datum',
    score:  'Ergebnis',
    scorei: 'Halbzeit',
    round:  'Spieltag',
    season: 'Saison',
    }


read( in_path, headers ) do |h|
  season = h.delete( :season )
  update_match( h, season: season )
end


## __END__


CsvMatchWriter.write( de_2013_14_path, MATCHES['2013-14'] )
