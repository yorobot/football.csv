
require 'sportdb/config'

SportDb::Import.config.leagues_dir = '../../../openfootball/leagues'


leagues = SportDb::Import.config.leagues
leagues.dump_duplicates


puts "** match AUT BL:"
pp leagues.match( 'AUT BL' )
pp leagues.match( 'aut bl' )
pp leagues.match( 'AUT' )
pp leagues.match( 'AUT 1' )
pp leagues.match( 'AT' )
pp leagues.match( 'AT 1' )
pp leagues.match( 'Austria 1' )

puts "** match CL:"
pp leagues.match( 'CL' )

puts "** match ENG PL:"
pp leagues.match( 'ENG PL' )

puts "** match ENG 1:"
pp leagues.match( 'ENG 1' )
