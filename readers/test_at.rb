require_relative 'build'


### "pre-load" leagues & clubs
LEAGUES = SportDb::Import.config.leagues
CLUBS   = SportDb::Import.config.clubs


setup( 'austria' )
read( 'austria' )


__END__
datafiles = Datafile.find_conf( "#{SOURCE_DIR}/austria" )
puts "#{datafiles.size} conf datafiles:"
pp datafiles

pack = Datafile::DirPackage.new( "#{SOURCE_DIR}/austria" )
## lint first (dry run - no database reads/updates/etc.)
pack.read( season: '2019/20', sync: false )
pack.read( '2011-12/.conf.txt', sync: false )
pack.read( '2011-12/1-bundesliga-i.txt', sync: false )
pack.read( '2011-12/1-bundesliga-ii.txt', sync: false )


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
