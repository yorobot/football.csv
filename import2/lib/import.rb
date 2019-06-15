# encoding: utf-8


#####
# todo:  rename importer to import  (use sportdb-import) for (new) gem name !!!
#


### patches - move to sportdb-text
require_relative 'text'

###
# our own code
require_relative 'read_db'


def import_matches_txt( path, season:, league:, country: )

  matches_txt = CsvMatchReader.read( path )

  ## note: allow keys (as string) or records
  season  = SportDb::Importer::Season.find( season )    if season.is_a? String
  league  = SportDb::Importer::League.find( league )    if league.is_a? String
  country = SportDb::Importer::Country.find( country )  if country.is_a? String

  update_matches_txt( matches_txt,
                        season:  season,
                        league:  league,
                        country: country )
end


def update_matches_txt( matches_txt, season:, league:, country: )

  matchlist = SportDb::Struct::Matchlist.new( matches_txt )
  teams_txt = matchlist.teams           ## was: find_teams_in_matches_txt( matches_txt )
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



class CsvPackage

def import_leagues( start: nil )   ## start - season e.g. 1993/94 to start (skip older seasons)
  ## note: assume package holds country/national (club) league
  #  use for importing german bundesliga, english premier league, etc.

  country_key = CountryUtils.key( @name )
  country = SportDb::Importer::Country.find( country_key )


  entries = find_entries_by_season

  entries.each_with_index do |entry,i|
    puts "season [#{i+1}/#{entries.size}] >#{entry[0]}<:"

    ## todo/fix: use File.basename alreay in find_entries_by_season!!!!!!
    ##   do NOT return  1990s/1993-94  but just 1993-94 - why? why not?
    season_basename = File.basename( entry[0] )

    if start && SeasonUtils.start_year( season_basename ) < SeasonUtils.start_year( start )
      puts "skip #{season_basename} before #{start}"
      next
    end

    season_key = SeasonUtils.key( season_basename )
    season     = SportDb::Importer::Season.find( season_key )

    datafiles = entry[1]
    datafiles.each_with_index do |datafile,j|
      puts "league [#{j+1}/#{datafiles.size}] >#{datafile}<:"
      basename = File.basename( datafile, '.csv' )
      level = LevelUtils.level( basename )
      league_key =  level == 1 ? country_key : "#{country_key}.#{level}"

      path = expand_path( datafile )
      pp [path, season_key, league_key, country_key]

      ## todo/fix:  support divisions!! e.g. 3a,3b etc - more than one league per level - how?
      ##   used in england
      league_auto_name = "#{country.name} League Level #{level}"   ## "fallback" auto-generated league name
      pp league_auto_name
      league = SportDb::Importer::League.find_or_create( league_key, name: league_auto_name )

      import_matches_txt( path,
              season:  season,
              league:  league,
              country: country )
    end
  end
end
end  # class CsvPackage
