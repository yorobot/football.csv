# encoding: utf-8


require 'sportdb/text'     ## csv (text) support
require 'sportdb/models'   ## db (sql) support


require_relative 'lib/import'     ## will become sportdb/import - why? why not?



## database = ':memory:'
database = './sco.db'
## database = './top.db'


SportDb.connect( adapter:  'sqlite3',
                 database: database )

## build schema
SportDb.create_all

matches_txt = CsvMatchReader.read( "../sco-scotland/2018-19/1-premiership.csv" )

season_key  = '2018/19'
league_key  = 'sco'   ## use sco.1 - for ??
country_key = 'sco'


season  = SportDb::Importer::Season.find( season_key )
league  = SportDb::Importer::League.find( league_key )
country = SportDb::Importer::Country.find( country_key )


## turn on logging to console
ActiveRecord::Base.logger = Logger.new(STDOUT)

update_matches_txt( matches_txt,
                      season:  season,
                      league:  league,
                      country: country )
