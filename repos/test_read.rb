require_relative 'boot'


path = "../../../footballcsv/espana/1920s/1928-29/es.1.csv"
matches = CsvMatchReader.read( path )

puts matches.size    #=> 90
pp matches[0]        #=> <Struct::Match>  date="1929-02-10"


matchlist = SportDb::Struct::Matchlist.new( matches )

# pp matchlist

puts matchlist.teams.size
puts matchlist.matches.size
puts matchlist.goals

puts matchlist.start_date? 
puts matchlist.end_date? 
puts matchlist.start_date.strftime( '%a %d %b %Y' )
puts matchlist.end_date.strftime( '%a %d %b %Y' )
