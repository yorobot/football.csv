
require 'sportdb/config'

SportDb::Import.config.leagues_dir = '../../../openfootball/leagues'


leagues = SportDb::Import.config.leagues
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
