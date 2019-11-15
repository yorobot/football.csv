require 'sportdb/readers'


SOURCE_DIR = '../../../openfootball'

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{SOURCE_DIR}/clubs"
SportDb::Import.config.leagues_dir = "#{SOURCE_DIR}/leagues"


datafiles = Datafile.find_conf( "#{SOURCE_DIR}/england" )
puts "#{datafiles.size} conf datafiles:"
pp datafiles

## lint first (dry run - no database reads/updates/etc.)
SportDb.read( "#{SOURCE_DIR}/england", sync: false )
## SportDb.read( "#{SOURCE_DIR}/deutschland", sync: false )

__END__


DB_FILE = './england.db'
File.delete( DB_FILE )  if File.exist?( DB_FILE )

SportDb.connect( adapter:  'sqlite3',
                 database: DB_FILE )
SportDb.create_all       ## build database schema (tables, indexes, etc.)


## turn on logging to console
ActiveRecord::Base.logger = Logger.new( STDOUT )


## SportDb.read( "#{SOURCE_DIR}/england" )


SportDb.read( "#{SOURCE_DIR}/england/2015-16/.conf.txt" )
SportDb.read( "#{SOURCE_DIR}/england/2015-16/1-premierleague-i.txt" )
SportDb.read( "#{SOURCE_DIR}/england/2015-16/1-premierleague-ii.txt" )

## let's try another season
SportDb.read( "#{SOURCE_DIR}/england/2019-20/.conf.txt" )
SportDb.read( "#{SOURCE_DIR}/england/2019-20/1-premierleague.txt" )
