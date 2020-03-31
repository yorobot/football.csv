# encoding: utf-8



## 3rd party libs / gems
require 'fetcher'

## sportdb libs / gems
require 'sportdb/match/formats'   # quick hack for now - missing as dependency? check - why? why not
require 'sportdb/import'

###
# our own code
require 'sportdb/source/footballdata/version' # let version always go first

require 'sportdb/source/footballdata/config'
require 'sportdb/source/footballdata/fetch'
require 'sportdb/source/footballdata/convert'




module Footballdata


def self.fetch( *args, dir: './dl', start: nil )   ## fetch all datasets (all leagues, all seasons)

  country_keys = args  ## countries to include / fetch - optinal

  FOOTBALLDATA_SOURCES.each do |country_key, country_sources|
    if country_keys.empty? || country_keys.include?( country_key )
      Footballdata.fetch_season_by_season( country_sources, dir: dir, start: start )
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

class << self
  alias_method :download, :fetch   ## add alias for fetch   ## todo: check if default kwarg dir gets set too
  alias_method :load,     :import
end



def self.import_season_by_season( country_key, sources, dir: )

  ## todo/check: make sure timezones entry for country_key exists!!! what results with nil/24.0 ??
  fix_date_converter = ->(row) { fix_date( row, FOOTBALLDATA_TIMEZONES[country_key]/24.0 ) }

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

      matches = CsvMatchReader.read( path, converters: fix_date_converter )

      update_matches_txt( matches,
                            league:  league,
                            season:  season )
    end
  end
end  # method import_season_by_season



def self.import_all_seasons( country_key, basename, dir: )

  col  = 'Season'
  path = "#{dir}/#{basename}.csv"

  season_keys = CsvMatchSplitter.find_seasons( path, col: col )
  pp season_keys

  ## note: assume always first level/tier league for now
  league_key = "#{country_key}.1"
  country, league = find_or_create_country_and_league( league_key )

  ## todo/check: make sure timezones entry for country_key exists!!! what results with nil/24.0 ??
  fix_date_converter = ->(row) { fix_date( row, FOOTBALLDATA_TIMEZONES[country_key]/24.0 ) }

  season_keys.each do |season_key|
    season = SportDb::Importer::Season.find_or_create_builtin( season_key )

    matches = CsvMatchReader.read( path, filters: { col => season_key },
                                         converters: fix_date_converter )

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

## helper to fix dates to use local timezone (and not utc/london time)
def self.fix_date( row, offset )
  return row    if row['Time'].nil?   ## note: time (column) required for fix

  col = row['Date']
  if col =~ /^\d{2}\/\d{2}\/\d{4}$/
    date_fmt = '%d/%m/%Y'   # e.g. 17/08/2002
  elsif col =~ /^\d{2}\/\d{2}\/\d{2}$/
    date_fmt = '%d/%m/%y'   # e.g. 17/08/02
  else
    puts "*** !!! wrong (unknown) date format >>#{col}<<; cannot continue; fix it; sorry"
    ## todo/fix: add to errors/warns list - why? why not?
    exit 1
  end

  date = DateTime.strptime( "#{row['Date']} #{row['Time']}", "#{date_fmt} %H:%M" )
  date = date + offset

  row['Date'] = date.strftime( date_fmt )  ## overwrite "old"
  row['Time'] = date.strftime( '%H:%M' )
  row   ## return row for possible pipelining - why? why not?
end



end ## module Footballdata



puts SportDb::Source::Footballdata.banner   # say hello
