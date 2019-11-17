require 'sportdb/readers'


SOURCE_DIR = '../../../openfootball'

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{SOURCE_DIR}/clubs"
SportDb::Import.config.leagues_dir = "#{SOURCE_DIR}/leagues"


def setup( dbname='football' )
  db_file = "./#{dbname}.db"
  File.delete( db_file )  if File.exist?( db_file )

  SportDb.connect( adapter:  'sqlite3',
                   database: db_file )
  SportDb.create_all       ## build database schema (tables, indexes, etc.)


  ## turn on logging to console
  ActiveRecord::Base.logger = Logger.new( STDOUT )
end


def read( name, season: '2019/20' )
  SportDb.read( "#{SOURCE_DIR}/#{name}", season: season )
end


setup()
read( 'england' )
read( 'austria' )
