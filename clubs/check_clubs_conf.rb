
require_relative '../lint/check_clubs'



## split into league + season
  ##  e.g. Österr. Bundesliga 2015/16   ## or 2015-16
  ##       World Cup 2018
  LEAGUE_SEASON_HEADING_REGEX =  /^
         (?<league>.+?)     ## non-greedy
            \s+
         (?<season>\d{4}
            (?:[\/-]\d{2})?     ## optional 2nd year in season
         )
            $/x

def check_clubs_by_events( nodes )
  count = 0

  nodes.each do |node|
    heading   = node[0]
    club_recs = node[1]

    values = heading.split( ',' )  ## note: allow rückrunde, clausura, etc.
    values = values.map { |value| value.strip }
    pp values

    if m=values[0].match( LEAGUE_SEASON_HEADING_REGEX )
      puts "league >#{m[:league]}<, season >#{m[:season]}<"

      m2 = LEAGUES.match( m[:league] )
      if m2.nil?
        puts "** !!! ERROR !!! - unknown league  >#{heading}< - sorry - add league to config to fix"
        exit 1
      else   ## todo/fix: check for more than one match error too!!!
        league = m2[0]
      end
    else
      puts "** !!! ERROR !!! - CANNOT match league and season in heading; season missing?"
      pp heading
      exit 1
    end

    missing = []

    club_recs.each do |h|    ## note: club records are hash tables
      name = h[:name]
      club = find_club( name, league.country )   ## todo/fix: add international or league flag?
      if club.nil?
        print "!!! >"
        missing << name
      else
        print "OK   "
      end
      print "#{name}"
      if club
        print " => #{club.name}"
      else
        print "<  !!!"
      end
      puts
    end

    if missing.empty?
      ## everything ok
    else
      puts "!!! #{missing.size} missing clubs in >#{heading}<:"
      pp missing
      count += missing.size
      ## append to missing clubs to errors file
      File.open( './errors.txt', 'a:utf-8' ) do |f|
        f.puts "!!! #{missing.size} missing clubs in >#{heading}<:"
        missing.each do |name|
          f.puts "   #{name}"
        end
      end
    end
  end

  if count == 0
    puts "OK - all clubs match"
  else
    puts "!!! found #{count} missing clubs, see error.txt for more"
  end
end



datafiles = Datafile.find_conf( '../../../openfootball/austria' )
# datafiles = Datafile.find_conf( '../../../openfootball/deutschland' )
# datafiles = Datafile.find_conf( '../../../openfootball/england' )
pp datafiles

datafiles.each do |datafile|

  nodes = SportDb::Import::ConfLinter.read( datafile )
  pp nodes

  check_clubs_by_events( nodes )
end
