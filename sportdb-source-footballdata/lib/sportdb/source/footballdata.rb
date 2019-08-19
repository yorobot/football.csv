# encoding: utf-8



## 3rd party libs / gems
require 'fetcher'

## sportdb libs / gems
require 'sportdb/text'


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

end ## module Footballdata




puts SportDb::Source::Footballdata.banner   # say hello
