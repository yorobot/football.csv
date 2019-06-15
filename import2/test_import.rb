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


country = SportDb::Importer::Country.find( 'es' )
season  = SportDb::Importer::Season.find( '2017/18' )

league = SportDb::Importer::League.find_or_create( 'es',
                                                   name: "#{country.name} League Level 1" )

import_matches_txt( '../es-espana/2017-18/1-liga.csv',
        season:  season,
        league:  league,
        country: country )


league = SportDb::Importer::League.find_or_create( 'es',
                                                   name: "#{country.name} League Level 2" )

import_matches_txt( '../es-espana/2017-18/2-liga2.csv',
        season:  season,
        league:  league,
        country: country )


__END__

import_matches_txt( '../sco-scotland/2018-19/1-premiership.csv',
        season:  '2018/19',
        league:  'sco',   ## use sco.1 - for ??
        country: 'sco' )

import_matches_txt( '../sco-scotland/2017-18/1-premiership.csv',
        season:  '2017/18',
        league:  'sco',   ## use sco.1 - for ??
        country: 'sco' )
