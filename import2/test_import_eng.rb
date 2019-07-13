# encoding: utf-8

require 'sportdb/import'



path = '../../footballcsv/england'
pack = CsvPackage.new( path )
## pp pack.find_entries_by_season_n_division
## pp pack.find_entries_by_season
pp pack.find_entries_by_code_n_season_n_division



__END__

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


__END__

fix:  note datafiles is now an array of datafiles (no longer just datafile!!!)
league [1/1] >["1880s/1888-89/eng.1.csv"]<:
sportdb-text-0.2.3/lib/sportdb/text/csv/package.rb:22:in `expand_path':
no implicit conversion of Array into String (TypeError)
