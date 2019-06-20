# encoding: utf-8

require 'sportdb/import'



database = ':memory:'
## database = './sco.db'
## database = './top.db'


SportDb.connect( adapter:  'sqlite3',
                 database: database )

## build schema
SportDb.create_all

## turn on logging to console
ActiveRecord::Base.logger = Logger.new(STDOUT)


country = SportDb::Importer::Country.find!( 'es' )
season  = SportDb::Importer::Season.find( '2017/18' )

league = SportDb::Importer::League.find_or_create( 'es',
                                                   name: "#{country.name} League 1" )

import_matches_txt( '../espana/2010s/2017-18/es.1.csv',
        season:  season,
        league:  league,
        country: country )


league = SportDb::Importer::League.find_or_create( 'es',
                                                   name: "#{country.name} League 2" )

import_matches_txt( '../espana/2010s/2017-18/es.2.csv',
        season:  season,
        league:  league,
        country: country )


__END__

import_matches_txt( '../scotland/2018-19/sco.1.csv',
        season:  '2018/19',
        league:  'sco',   ## use sco.1 - for ??
        country: 'sco' )

import_matches_txt( '../scotland/2017-18/sco.1.csv',
        season:  '2017/18',
        league:  'sco',   ## use sco.1 - for ??
        country: 'sco' )
