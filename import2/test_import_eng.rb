# encoding: utf-8

require 'sportdb/import'


database = ':memory:'
## database = './eng.db'
## database = './top.db'


SportDb.connect( adapter:  'sqlite3',
                 database: database )

## build schema
SportDb.create_all

## turn on logging to console
ActiveRecord::Base.logger = Logger.new(STDOUT)

pack = CsvMatchImporter.new( '../england' )
pack.import_leagues


__END__

=begin
league [1/4] >1930s/1939-40/1-division1.csv<:
["eng-england/1930s/1939-40/1-division1.csv",
 "1939/40",
 "eng",
 "eng"]

football.csv/import2/lib/import.rb:75:in `strptime': no implicit conversion of nil into String (TypeError)
        from football.csv/import2/lib/import.rb:75:in `block in update_matches_txt'

!!! check dataset - match date is missing!!!!
=end

country = SportDb::Importer::Country.find( 'eng' )
season  = SportDb::Importer::Season.find( '1939/40' )

league = SportDb::Importer::League.find_or_create( 'eng',
                                                   name: "#{country.name} League 1" )

import_matches_txt( '../england/1930s/1939-40/eng.1.csv',
        season:  season,
        league:  league,
        country: country )
