# encoding: utf-8

require 'sportdb/import'



path = '../../footballcsv/england'

## pack = CsvPackage.new( path )
## pp pack.find_entries_by_season_n_division
## pp pack.find_entries_by_season
## pp pack.find_entries_by_code_n_season_n_division



database = ':memory:'
## database = './eng.db'


SportDb.connect( adapter:  'sqlite3',
                 database: database )

## build schema
SportDb.create_all

## turn on logging to console
ActiveRecord::Base.logger = Logger.new(STDOUT)


SportDb::Import.config.clubs_dir = '../../openfootball/clubs'

pack = CsvMatchImporter.new( path )
pack.import_leagues
