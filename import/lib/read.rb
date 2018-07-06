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
require_relative 'structs/match'
require_relative 'structs/standings'
require_relative 'structs/teams'


require_relative 'config'


require_relative 'csv/reader'
require_relative 'csv/converter'
require_relative 'csv/package'
require_relative 'csv/standings'
require_relative 'csv/reports/seasons.rb'
require_relative 'csv/reports/summary.rb'
require_relative 'csv/reports/teams.rb'




require_relative 'read_txt'
require_relative 'read_db'



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
