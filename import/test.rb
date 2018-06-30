# encoding: utf-8


require_relative 'lib/read'



database = ':memory:'
## database = './eng.db'
## database = './top.db'


SportDb.connect( adapter:  'sqlite3',
                 database: database )

## build schema
SportDb.create_all



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





FOOTBALLDATA_SOURCES =
{
  eng: [
         [ '2017-18', %w(E0) ]
       ],
  fr:  [
         [ '2013-14', %w(F1) ]
       ]
}

FOOTBALLDATA_SOURCES.each do |country_key, sources|
  country = SportDb::Importer::Country.find( country_key )

  sources.each do |source|
      puts "source:"
      pp source

      season_key      = source[0]
      league_keys_txt = source[1]

      season  = SportDb::Importer::Season.find( season_key )
      pp league_keys_txt
      league_keys_txt.each do |league_key_txt|
        league_key = FOOTBALLDATA_LEAGUES[ league_key_txt ]
        league  = SportDb::Importer::League.find( league_key )

        ## e.g. ./dl/eng-england/2017-18/E0.csv
        matches_txt = find_matches_in_txt( "./dl/#{COUNTRY_REPOS[country_key]}/#{season_key}/#{league_key_txt}.csv" )
        puts "#{matches_txt.size} matches:"

        update_matches_txt( matches_txt,
                            season:  season,
                            league:  league,
                            country: country )
      end
  end
end



FOOTBALLDATA_SOURCES_II =
{
  at: 'AUT',   ## all seasons in one file
}

FOOTBALLDATA_SOURCES_II.each do |country_key, league_key_txt|
  country = SportDb::Importer::Country.find( country_key )

  league_key = FOOTBALLDATA_LEAGUES[ league_key_txt ]
  league  = SportDb::Importer::League.find( league_key )

  ## e.g. ./dl/at-austria/AT.csv
  season_keys =  find_seasons_in_txt( "./dl/#{COUNTRY_REPOS[country_key]}/#{league_key_txt}.csv" )
  season_keys.each do |season_key|
    season  = SportDb::Importer::Season.find( season_key )

    matches_txt = find_matches_in_txt( "./dl/#{COUNTRY_REPOS[country_key]}/#{league_key_txt}.csv",
                                       season: season_key )
    puts "#{matches_txt.size} matches:"

    update_matches_txt( matches_txt,
                        season:  season,
                        league:  league,
                        country: country )
  end
end
