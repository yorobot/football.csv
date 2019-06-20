# encoding: utf-8

require 'sportdb/import'



database = ':memory:'
## database = './es.db'
## database = './top.db'


SportDb.connect( adapter:  'sqlite3',
                 database: database )

## build schema
SportDb.create_all

## turn on logging to console
ActiveRecord::Base.logger = Logger.new(STDOUT)



pack = CsvMatchImporter.new( '../espana' )
pack.import_leagues( start: '1993/94' )   ## skip seasons before 1993/94
