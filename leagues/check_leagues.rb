## check leagues

require 'pp'

def read_lines( path )
  txt = File.open( path, 'r:utf-8') { |f| f.read }
  lines = []
  txt.each_line do |line|
     line = line.strip
     next if line.empty?
     next if line.start_with?( '#' )

     line = line.sub( /#.*/, '' ).strip   ## note: add / allow inline end-of-line support
     lines << line
  end
  lines
end



leagues = read_lines( 'espn.txt' )
pp leagues


require 'sportdb/config'

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"
SportDb::Import.config.leagues_dir = "../../../openfootball/leagues"

LEAGUES = SportDb::Import.config.leagues



leagues.each do |l|
  m = LEAGUES.match( l )
  if m
    if m.size == 1
      print "    "
    else
      ## check for ambigious (multiple) matches too (and warn)
      print " !! ambigious (multiple) matches (#{m.size})"
      pp m
    end
  else
    print "!!! "
  end
  puts "   #{l}"
end
