
require 'sportdb/source/footballdata'


SportDb.connect( adapter:  'sqlite3',
                 database: './football.db' )


## turn on logging to console
ActiveRecord::Base.logger = Logger.new(STDOUT)

## show some stats
Team   = SportDb::Model::Team
Game   = SportDb::Model::Game
League = SportDb::Model::League
Event  = SportDb::Model::Event

puts Team.count   #=> 1143
# SELECT COUNT(*) FROM teams

puts Game.count   #=> 227_142
# SELECT COUNT(*) FROM games

puts League.count  #=> 38
# SELECT COUNT(*) FROM leagues




#  Note: See the SUMMARY.md page for a list of all (canonical) club names by country.

## games of real madrid

madrid = Team.find_by( title: 'Real Madrid' )
# SELECT * FROM teams WHERE title = 'Real Madrid' LIMIT 1

puts madrid.games.count   #=> 1023
# SELECT COUNT(*) FROM games WHERE (team1_id = 380 or team2_id = 380)
g = madrid.games.first
# SELECT * FROM "games" WHERE (team1_id = 380 or team2_id = 380) LIMIT 1

puts g.team1.title #=> CA Osasuna
puts g.team2.title #=> Real Madrid
puts g.score_str   #=> 1 - 4


## games of liverpool

liverpool = Team.find_by( title: 'Liverpool FC' )

puts liverpool.games.count  #=> 1025

g = liverpool.games.first
puts g.team1.title  #=> Liverpool FC
puts g.team2.title  #=> Sheffield Wednesday FC
puts g.score_str    #=> 2 - 0

## english premier league 2019/20

epl = Event.find_by( key: 'eng.1.2019/20' )

puts epl.games.count  #=> 288

g = epl.games.first
puts g.team1.title  #=> Liverpool FC
puts g.team2.title  #=> Norwich City FC
puts g.score_str    #=> 4 - 1


# and so on