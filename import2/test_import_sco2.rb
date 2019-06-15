# encoding: utf-8


require 'sportdb/text'     ## csv (text) support
require 'sportdb/models'   ## db (sql) support


require_relative 'lib/import'     ## will become sportdb/import - why? why not?


#######################################
## add to sportdb-text
module CountryHelper ## use Helpers why? why not?

  def key( basename )
    if basename =~ /^([a-z]{2,3})-/    ## check for leading country code (e.g. sco-scotland)
      $1   ## return code as string e.g. "sco"
    else
      puts "sorry unknown country - cannot auto-map from >#{basename}< - add to CountryHelper to fix"
      exit 1
    end
  end
  def code( basename ) key( basename ); end  ## alias for country_key/code

end  # module CountryHelper


module CountryUtils
  extend CountryHelper
  ##  lets you use CountryHelper as "globals" eg.
  ##     CountryUtils.key( basename ) etc.
end # CountryUtils


module SeasonHelper ## use Helpers why? why not?
  def key( basename )
    ## todo: add 1964-1965 format too!!!
    if basename =~ /^(\d{4})-(\d{2})$/    ## season format is  1964-65
      "#{$1}/#{$2}"
    elsif basename =~ /^(\d{4})$/
      $1
    else
      puts "*** !!!! wrong season format >>#{basename}<<; exit; sorry"
      exit 1
    end
  end  # method key
end


class CsvPackage

def import_leagues
  ## note: assume package holds country/national (club) league
  #  use for importing german bundesliga, english premier league, etc.

  country_key = CountryUtils.key( @name )
  country = SportDb::Importer::Country.find( country_key )


  entries = find_entries_by_season

  entries.each_with_index do |entry,i|
    puts "season [#{i+1}/#{entries.size}] >#{entry[0]}<:"
    season_key = SeasonUtils.key( entry[0] )
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





database = ':memory:'
## database = './sco.db'
## database = './top.db'


SportDb.connect( adapter:  'sqlite3',
                 database: database )

## build schema
SportDb.create_all

## turn on logging to console
ActiveRecord::Base.logger = Logger.new(STDOUT)


pack = CsvPackage.new( '../sco-scotland' )
pack.import_leagues
