# encoding: utf-8


require 'pp'
require 'csv'
require 'date'

####
#  load / import csv file into football.db database






## step 1
##   find all teams
##   find season for auto-creating event/season/teams etc.

##
##  todo/fix: always use utf8 in file read/write!!!


## unify team names; team (builtin/known/shared) name mappings
TEAMS = { }



def find_teams( path_in )

  teams = Hash.new( 0 )   ## default value is 0


  csv = CSV.read( path_in, headers: true )

  ### todo/fix: check headers - how?
  ##  if present HomeTeam or HT required etc.
  ##   issue error/warn is not present
  ##
  ## puts "*** !!! wrong (unknown) headers format; cannot continue; fix it; sorry"
  ##    exit 1
  ##

  csv.each_with_index do |row,i|

    puts "[#{i}] " + row.inspect  if i < 2

    # note: greece 2001-02 etc. use HT  -  check CVS reader  row['HomeTeam'] may not be nil but an empty string?
    #   e.g. row['HomeTeam'] || row['HT'] will NOT work for now
    team1 = row['HomeTeam']
    if team1.nil? || team1.strip.empty?   ## todo: check CVS reader - what does it return for non-existing valules/columns?
      team1 = row['HT']
    end

    team2 = row['AwayTeam']
    if team2.nil? || team2.strip.empty?
      team2 =row['AT']
    end

    ## reformat team if match  (e.g. Bayern Munich => Bayern München etc.)
    team1 = TEAMS[ team1 ]   if TEAMS[ team1 ]
    team2 = TEAMS[ team2 ]   if TEAMS[ team2 ]


    teams[ team1 ] += 1
    teams[ team2 ] += 1
  end

  teams
end

teams = find_teams( './dl/eng-england/2017-18/E0.csv' )
puts "#{teams.size} teams:"
pp teams


require 'sportdb/models'

SportDb.connect( adapter:  'sqlite3',
                 database: ':memory:' )

## build schema
SportDb.create_all

### check country
country = WorldDb::Model::Country.find_by( key: 'eng' )
if country.nil?
   country = WorldDb::Model::Country.create!(
     key:  'eng',
     name: 'England',
     code: 'ENG',
     area: 1,
     pop:  1
   )
end

pp country


## add teams

team_name = teams.keys[0]
team_key  = team_name.downcase

team = SportDb::Model::Team.find_by( title: team_name )
if team.nil?
  team = SportDb::Model::Team.create!(
    key:   team_key,
    title: team_name,
    country_id: country.id
   )
end

pp team




### add season

season = SportDb::Model::Season.find_by( key: '2017-18' )
if season.nil?
  season = SportDb::Model::Season.create!(
    key:   '2017-18',
    title: '2017-18'
  )
end

pp season

### add league
##  en,    English Premier League
league = SportDb::Model::League.find_by( key: 'en' )
if league.nil?
   league = SportDb::Model::League.create!(
     key:   'en',
     title: 'English Premier League'
   )
end

pp league


## add event
event = SportDb::Model::Event.find_by( key: 'en.2017/18' )
if event.nil?
  event = SportDb::Model::Event.create!(
    league_id: league.id,
    season_id: season.id,
    start_at:  Date.new( 2017, 7, 1 )
   )
end

pp event
