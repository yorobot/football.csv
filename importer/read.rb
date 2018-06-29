# encoding: utf-8



#####
# todo:  rename importer to import  (use sportdb-import) for (new) gem name !!!
#


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


def find_teams_in_txt( path_in )

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

  pp teams

  ## note: only return team names (not hash with usage counter)
  teams.keys
end




require 'sportdb/models'

SportDb.connect( adapter:  'sqlite3',
                 database: ':memory:' )

## build schema
SportDb.create_all





## built-in countries for (quick starter) auto-add
COUNTRIES = {    ## rename to AUTO or BUILTIN_COUNTRIES or QUICK_COUNTRIES - why? why not?
  eng: ['England',  'ENG'],     ## title/name, code
}

def find_country( key )   ## e.g. key = 'eng' or 'de' etc.

   country = WorldDb::Model::Country.find_by( key: key )
   if country.nil?
     ### check quick built-tin auto-add country data
     data = COUNTRIES[ key.to_sym ]
     if data.nil?
       puts "** unknown country for key >#{key}<; sorry - add to COUNTRIES table"
       exit 1
     end

     name, code = data

     country = WorldDb::Model::Country.create!(
        key:  key,
        name: name,
        code: code,
        area: 1,
        pop:  1
     )
   end
   pp country
   country
end



def find_teams( team_names, country: )
  recs = []

  ## add/find teams
  team_names.each do |team_name|
    ## remove spaces too (e.g. Man City => mancity)
    team_key  = team_name.downcase.gsub( /[ ]/, '' )

    puts "add team: #{team_key}, #{team_name}:"

    team = SportDb::Model::Team.find_by( title: team_name )
    if team.nil?
       team = SportDb::Model::Team.create!(
         key:   team_key,
         title: team_name,
         country_id: country.id
       )
    end
    pp team
    recs << team
  end

  recs  # return activerecord team objects
end


### add season
def find_season( key )  ## e.g. key = '2017-18'
  ## todo/fix:
  ##   always use 2017/18  or 2017-18
  ##    use search and replace to change / to - or similar!!!
  season = SportDb::Model::Season.find_by( key: key )
  if season.nil?
     season = SportDb::Model::Season.create!(
       key:   key,
       title: key
     )
  end
  pp season
  season
end



## built-in countries for (quick starter) auto-add
LEAGUES = {    ## rename to AUTO or BUILTIN_LEAGUES or QUICK_LEAGUES  - why? why not?
  en: 'English Premier League',
}


### add league
def find_league( key )  ## e.g. key = 'en' or 'en.2' etc.
  ##  en,    English Premier League
  league = SportDb::Model::League.find_by( key: key )
  if league.nil?
     ### check quick built-tin auto-add league data
     data = LEAGUES[ key.to_sym ]
     if data.nil?
       puts "** unknown league for key >#{key}<; sorry - add to LEAGUES table"
       exit 1
     end

     name = data

     league = SportDb::Model::League.create!(
        key:   key,
        title: name,  # e.g. 'English Premier League'
     )
  end
  pp league
  league
end


def find_event( league:, season: )
  ## add event
  ##  key = 'en.2017/18'
  event = SportDb::Model::Event.find_by( league_id: league.id, season_id: season.id  )
  if event.nil?
    ## quick hack/change later !!
    ##  start_at use year and 7,1 e.g. Date.new( 2017, 7, 1 )
    year = season.key[0..3].to_i  ## eg. 2017-18 => 2017
    event = SportDb::Model::Event.create!(
       league_id: league.id,
       season_id: season.id,
       start_at:  Date.new( year, 7, 1 )
     )
  end
  pp event
  event
end





country = find_country( 'eng' )
league  = find_league( 'en' )

['2017-18', '2016-17' ].each do |season_txt|
   teams_txt = find_teams_in_txt( "./dl/eng-england/#{season_txt}/E0.csv" )
   puts "#{teams_txt.size} teams:"
   pp teams_txt

   teams   = find_teams( teams_txt, country: country )
   season  = find_season( season_txt )
   event   = find_event( season: season, league: league )
end
