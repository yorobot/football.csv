# encoding: utf-8

require_relative 'lib/import'



database = ':memory:'
## database = './eng.db'
## database = './top.db'


SportDb.connect( adapter:  'sqlite3',
                 database: database )

## build schema
SportDb.create_all

matches_txt = CsvMatchReader.read( "./o/eng-england/2017-18/1-premierleague.csv" )

season_key  = '2017/18'
league_key  = 'en'   ## use eng.1 - for English Premier League ??
country_key = 'eng'


season  = SportDb::Importer::Season.find( season_key )
league  = SportDb::Importer::League.find( league_key )
country = SportDb::Importer::Country.find( country_key )


## turn on logging to console
ActiveRecord::Base.logger = Logger.new(STDOUT)

update_matches_txt( matches_txt,
                      season:  season,
                      league:  league,
                      country: country )
