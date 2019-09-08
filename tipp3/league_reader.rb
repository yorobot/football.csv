
require 'sportdb/config'
require 'sportdb/leagues'


SportDb::Import::LeagueReader.config  =  SportDb::Import.config
SportDb::Import::LeagueIndex.config   =  SportDb::Import.config


recs = SportDb::Import::LeagueReader.read( 'leagues.txt' )
pp recs

leagues = SportDb::Import::LeagueIndex.new
leagues.add( recs )
leagues.dump_duplicates

puts "** match AUT BL:"
pp leagues.match( 'AUT BL' )
pp leagues.match( 'aut bl' )

puts "** match CL:"
pp leagues.match( 'CL' )

puts "** match ENG PL:"
pp leagues.match( 'ENG PL' )

puts "** match ENG 1:"
pp leagues.match( 'ENG 1' )
