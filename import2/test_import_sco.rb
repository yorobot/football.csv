# encoding: utf-8


require 'sportdb/text'     ## csv (text) support
require 'sportdb/models'   ## db (sql) support


require_relative 'lib/import'     ## will become sportdb/import - why? why not?

database = ':memory:'
## database = './sco.db'
## database = './top.db'


SportDb.connect( adapter:  'sqlite3',
                 database: database )

## build schema
SportDb.create_all

## turn on logging to console
ActiveRecord::Base.logger = Logger.new(STDOUT)

## pack = CsvPackage.new( '../scotland' )
## pp pack.find_entries_by_season_n_division


pack = CsvMatchImporter.new( '../scotland' )
pack.import_leagues
