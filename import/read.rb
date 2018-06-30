# encoding: utf-8



#####
# todo:  rename importer to import  (use sportdb-import) for (new) gem name !!!
#


require 'pp'
require 'csv'
require 'date'


require 'sportdb/models'


###
# our own code
require_relative 'read_txt'
require_relative 'read_db'




## database = ':memory:'
## database = './eng.db'
database = './top.db'


SportDb.connect( adapter:  'sqlite3',
                 database: database )

## build schema
SportDb.create_all




def update_matches_txt( matches_txt, season:, league:, country: )

  teams_txt = find_teams_in_matches_txt( matches_txt )
  puts "#{teams_txt.size} teams:"
  pp teams_txt

  ## note: assume for now team all from same country
  ##   fix!!! - english premier league has teams from wales
  ##            french ligue 1 from monaco
  teams = find_teams( teams_txt, country: country )

  ## build hash lookup table e.g.
  #  { 'Liverpool' => obj, ... }
  teams_mapping = Hash[ teams_txt.zip( teams ) ]



  event   = find_event( season: season, league: league )

  ## add teams to event
  ##   todo/fix: check if team is alreay included?
  ##    or clear/destroy_all first!!!
  teams.each do |team|
    event.teams << team
  end

  ## add catch-all/unclassified "dummy" round
  round = SportDb::Model::Round.create!(
    event_id: event.id,
    title:    'Matchday ??? / Missing / Catch-All',   ## find a better name?
    pos:      999,
    start_at: event.start_at.to_date
  )

  ## add matches
  matches_txt.each do |match_txt|
    team1 = teams_mapping[match_txt.team1]
    team2 = teams_mapping[match_txt.team2]

    match = SportDb::Model::Game.create!(
      team1_id: team1.id,
      team2_id: team2.id,
      round_id: round.id,
      pos:      999,    ## make optional why? why not? - change to num?
      play_at:  Date.strptime( match_txt.date, '%Y-%m-%d' ),
      score1:   match_txt.score1,
      score2:   match_txt.score2,
      score1i:  match_txt.score1i,
      score2i:  match_txt.score2i,
    )
    ## pp match
  end
end





FOOTBALLDATA_SOURCES =
{
  eng: [
         [ '2017-18', %w(E0) ]
       ],
  fr:  [
         [ '2013-14', %w(F1) ]
       ],
  at: 'AUT',   ## all seasons in one file
}


## map football_data leagues to our own keys

FOOTBALLDATA_LEAGUES = {
  'E0'  => 'en',     # english premier league
  'E1'  => 'en.2',   # english championship league
  'E2'  => 'en.3',   # english league 1
  'E3'  => 'en.4',   # english league 2
  'EC'  => 'en.5',   # english conference

  'F1'  => 'fr',     # french ligue 1
  'F2'  => 'fr.2',   # french ligue 2

  ## all seasons in one file
  'AUT'  => 'at',   ## austrian bundelsliga
}


COUNTRY_REPOS = {
  eng:  'eng-england',
  es:   'es-espana',
  de:   'de-deutschland',
  fr:   'fr-france',
  it:   'it-italy',
  sco:  'sco-scotland',
  nl:   'nl-netherlands',
  be:   'be-belgium',
  pt:   'pt-portugal',
  tr:   'tr-turkey',
  gr:   'gr-greece',
  at:   'at-austria',
}




FOOTBALLDATA_SOURCES.each do |country_key, sources|
  country = find_country( country_key )

  if sources.is_a? Array
    sources.each do |source|
      puts "source:"
      pp source

      season_key      = source[0]
      league_keys_txt = source[1]

      season  = find_season( season_key )
      pp league_keys_txt
      league_keys_txt.each do |league_key_txt|
        league_key = FOOTBALLDATA_LEAGUES[ league_key_txt ]
        league  = find_league( league_key )

        ## e.g. ./dl/eng-england/2017-18/E0.csv
        matches_txt = find_matches_in_txt( "./dl/#{COUNTRY_REPOS[country_key]}/#{season_key}/#{league_key_txt}.csv" )
        puts "#{matches_txt.size} matches:"

        update_matches_txt( matches_txt,
                            season:  season,
                            league:  league,
                            country: country )
      end
    end
  else  ## assume single string
    league_key_txt = sources

    league_key = FOOTBALLDATA_LEAGUES[ league_key_txt ]
    league  = find_league( league_key )

    ## e.g. ./dl/at-austria/AT.csv
    season_keys =  find_seasons_in_txt( "./dl/#{COUNTRY_REPOS[country_key]}/#{league_key_txt}.csv" )
    season_keys.each do |season_key|
      season  = find_season( season_key )

      matches_txt = find_matches_in_txt( "./dl/#{COUNTRY_REPOS[country_key]}/#{league_key_txt}.csv",
                                         season: season_key )
      puts "#{matches_txt.size} matches:"

      update_matches_txt( matches_txt,
                          season:  season,
                          league:  league,
                          country: country )
    end
  end
end
