###
#  test import
#   start time: 11:24
#   end time:   12:20 !!
#
#   do NOT turn on logging!!!! for speed-up

require 'sportdb/source/footballdata'


SportDb.connect( adapter:  'sqlite3',
                 database: './football.db' )

## build database schema / tables
SportDb.create_all

## turn on logging to console
## ActiveRecord::Base.logger = Logger.new(STDOUT)

Footballdata.import

