# encoding: utf-8



## 3rd party libs / gems
require 'fetcher'

## sportdb libs / gems
require 'sportdb/import'


###
# our own code
require 'sportdb/source/footballdata/version' # let version always go first

require 'sportdb/source/footballdata/config_i'
require 'sportdb/source/footballdata/config_ii'
require 'sportdb/source/footballdata/fetch'
require 'sportdb/source/footballdata/convert'




module Footballdata


def self.fetch( *args, dir: './dl' )   ## fetch all datasets (all leagues, all seasons)

  country_keys = args  ## countries to include / fetch - optinal

  FOOTBALLDATA_SOURCES.each do |country_key, country_sources|
    if country_keys.empty? || country_keys.include?( country_key )
      Footballdata.fetch_season_by_season( country_sources, dir: dir )
    else
      ## skipping country
    end
  end

  FOOTBALLDATA_SOURCES_II.each do |country_key, country_basename|
    if country_keys.empty? || country_keys.include?( country_key )
      Footballdata.fetch_all_seasons( country_basename, dir: dir )
    else
      ## skipping country
    end
  end
end  ## method fetch
def self.download( *args, dir: './dl' ) fetch( *args, dir: dir ); end  ## add alias for fetch



def self.import( *args, dir: './dl' )

  country_keys = args  ## countries to include / fetch - optinal

  FOOTBALLDATA_SOURCES.each do |country_key, country_sources|
    if country_keys.empty? || country_keys.include?( country_key )
      Footballdata.import_season_by_season( country_key, country_sources, dir: dir )
    else
      ## skipping country
    end
  end

  FOOTBALLDATA_SOURCES_II.each do |country_key, country_basename|
    if country_keys.empty? || country_keys.include?( country_key )
      Footballdata.import_all_seasons( country_key, country_basename, dir: dir )
    else
      ## skipping country
    end
  end
end # method import
def self.load( *args, dir: './dl' ) import( *args, dir: dir ); end  ## add alias for import



def self.import_season_by_season( country_key, sources, dir: )

  sources.each do |rec|
    season_key  = rec[0]   ## note: dirname is season_key e.g. 2011-12 etc.
    basenames  = rec[1]   ## e.g. E1,E2,etc.

    basenames.each do |basename|

      path = "#{dir}/#{season_key}/#{basename}.csv"

      league_key = FOOTBALLDATA_LEAGUES[basename]  ## e.g.: eng.1, fr.1, fr.2 etc.
      if league_key.nil?
        puts "** !!! ERROR !!! league key missing for >#{basename}<; sorry - please add"
        exit 1
      end

      country, league = find_or_create_country_and_league( league_key )

      season = SportDb::Importer::Season.find_or_create_builtin( season_key )

      puts "path: #{path}"

      matches = CsvMatchReader.read( path )

      update_matches_txt( matches,
                            league:  league,
                            season:  season )
    end
  end
end  # method import_season_by_season



def self.import_all_seasons( country_key, basename, dir: )

  col  = 'Season'
  headers = {
    team1: 'Home',
    team2: 'Away',
    date:  'Date',
    score1: 'HG',
    score2: 'AG',
  }

  path = "#{dir}/#{basename}.csv"

  season_keys = CsvMatchSplitter.find_seasons( path, col: col )
  pp season_keys

  ## note: assume always first level/tier league for now
  league_key = "#{country_key}.1"
  country, league = find_or_create_country_and_league( league_key )

  season_keys.each do |season_key|
    season = SportDb::Importer::Season.find_or_create_builtin( season_key )


    matches = CsvMatchReader.read( path, headers: headers, filters: { col => season_key } )

    pp matches[0..2]
    pp matches.size

    update_matches_txt( matches,
                          league:  league,
                          season:  season )
  end
end  # method import_all_seasons



###
## helper for country and league db record
def self.find_or_create_country_and_league( league_key )
  country_key, level = league_key.split( '.' )
  country = SportDb::Importer::Country.find_or_create_builtin!( country_key )

  league_auto_name = "#{country.name} #{level}"   ## "fallback" auto-generated league name
  pp league_auto_name
  league = SportDb::Importer::League.find_or_create( league_key,
                                                       name:       league_auto_name,
                                                       country_id: country.id )

  [country, league]
end

end ## module Footballdata



puts SportDb::Source::Footballdata.banner   # say hello
