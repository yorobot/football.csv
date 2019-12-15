require 'sportdb/readers'


SOURCE_DIR = '../../../openfootball'

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{SOURCE_DIR}/clubs"
SportDb::Import.config.leagues_dir = "#{SOURCE_DIR}/leagues"


def setup( dbname='football' )
  dbfile = "./#{dbname}.db"
  File.delete( dbfile )  if File.exist?( dbfile )

  SportDb.connect( adapter:  'sqlite3',
                   database: dbfile )
  SportDb.create_all       ## build database schema (tables, indexes, etc.)


  ## turn on logging to console
  ActiveRecord::Base.logger = Logger.new( STDOUT )
end



def read( name, season: nil )
  pack = SportDb::DirPackage.new( "#{SOURCE_DIR}/#{name}" )
  pack.read( season: season )
end
