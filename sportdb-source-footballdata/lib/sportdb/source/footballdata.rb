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


def self.fetch( *args, out_dir: './dl' )   ## fetch all datasets (all leagues, all seasons)

  country_keys = args  ## countries to include / fetch - optinal

  FOOTBALLDATA_SOURCES.each do |country_key, country_sources|
    if country_keys.empty? || country_keys.include?( country_key )
      Footballdata.fetch_season_by_season( country_sources, out_dir: out_dir )
    else
      ## skipping country
    end
  end

  FOOTBALLDATA_SOURCES_II.each do |country_key, country_basename|
    if country_keys.empty? || country_keys.include?( country_key )
      Footballdata.fetch_all_seasons( country_basename, out_dir: out_dir )
    else
      ## skipping country
    end
  end
end  ## method fetch
def self.download( *args, out_dir: './dl' ) fetch( *args, out_dir: out_dir ); end  ## add alias for fetch



def self.import( *args, in_dir: './dl' )

  country_keys = args  ## countries to include / fetch - optinal

  FOOTBALLDATA_SOURCES.each do |country_key, country_sources|
    if country_keys.empty? || country_keys.include?( country_key )
      Footballdata.import_season_by_season( country_sources, in_dir: in_dir )
    else
      ## skipping country
    end
  end

  FOOTBALLDATA_SOURCES_II.each do |country_key, country_basename|
    if country_keys.empty? || country_keys.include?( country_key )
      Footballdata.import_all_seasons( country_basename, in_dir: in_dir )
    else
      ## skipping country
    end
  end
end # method import
def self.load( *args, in_dir: './dl' ) import( *args, in_dir: in_dir ); end  ## add alias for import


def self.import_season_by_season( sources, in_dir: )
  in_root = in_dir   # e.g. "./dl/#{repo}"

  sources.each do |rec|
    dirname   = rec[0]   ## note: dirname is season e.g. 2011-12 etc.
    basenames = rec[1]   ## e.g. E1,E2,etc.

    basenames.each do |basename|

      in_path = "#{in_root}/#{dirname}/#{basename}.csv"

      league_key = FOOTBALLDATA_LEAGUES[basename]  ## e.g.: eng.1, fr.1, fr.2 etc.
      if league_key.nil?
        puts "** !!! ERROR !!! league key missing for >#{basename}<; sorry - please add"
        exit 1
      end

      country_key, level = league_key.split( '.' )
      country = SportDb::Importer::Country.find_or_create_builtin!( country_key )

      season = SportDb::Importer::Season.find_or_create_builtin( dirname )

      league_auto_name = "#{country.name} #{level}"   ## "fallback" auto-generated league name
      pp league_auto_name
      league = SportDb::Importer::League.find_or_create( league_key,
                                                           name:       league_auto_name,
                                                           country_id: country.id )


      puts "in_path: #{in_path}"

      matches = CsvMatchReader.read( in_path )

      update_matches_txt( matches,
                            league:  league,
                            season:  season )
    end
  end
end  # method import_season_by_season



def self.import_all_seasons( basename, in_dir: )
end  # method import_all_seasons

end ## module Footballdata



puts SportDb::Source::Footballdata.banner   # say hello
