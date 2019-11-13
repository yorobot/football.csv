require 'sportdb/readers'


SOURCE_DIR = '../../../openfootball'

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{SOURCE_DIR}/clubs"
SportDb::Import.config.leagues_dir = "#{SOURCE_DIR}/leagues"


datafiles = Datafile.find_conf( "#{SOURCE_DIR}/austria" )
puts "#{datafiles.size} conf datafiles:"
pp datafiles

## lint first (dry run - no database reads/updates/etc.)
SportDb.read( "#{SOURCE_DIR}/austria", sync: false )


__END__
# 5 conf datafiles:
# ["../../../openfootball/austria/2011-12/.conf.txt",
# "../../../openfootball/austria/2012-13/.conf.txt",
# "../../../openfootball/austria/2013-14/.conf.txt",
# "../../../openfootball/austria/2014-15/.conf.txt",
# "../../../openfootball/austria/2018-19/.conf.txt"]


DB_FILE = './austria.db'
File.delete( DB_FILE )  if File.exist?( DB_FILE )

SportDb.connect( adapter:  'sqlite3',
                 database: DB_FILE )
SportDb.create_all       ## build database schema (tables, indexes, etc.)


## turn on logging to console
ActiveRecord::Base.logger = Logger.new( STDOUT )


## SportDb.read( "#{SOURCE_DIR}/austria" )


SportDb.read( "#{SOURCE_DIR}/austria/2011-12/.conf.txt" )
SportDb.read( "#{SOURCE_DIR}/austria/2011-12/1-bundesliga-i.txt" )
SportDb.read( "#{SOURCE_DIR}/austria/2011-12/1-bundesliga-ii.txt" )

## let's try another season
SportDb.read( "#{SOURCE_DIR}/austria/2012-13/.conf.txt" )
SportDb.read( "#{SOURCE_DIR}/austria/2012-13/1-bundesliga-i.txt" )
SportDb.read( "#{SOURCE_DIR}/austria/2012-13/1-bundesliga-ii.txt" )
