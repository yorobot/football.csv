require_relative 'build'


### "pre-load" leagues & clubs
LEAGUES = SportDb::Import.config.leagues
CLUBS   = SportDb::Import.config.clubs


setup( 'england' )
## read( 'england', season: '2019/20' )
read( 'england' )




__END__

datafiles = Datafile.find_conf( "#{SOURCE_DIR}/england" )
puts "#{datafiles.size} conf datafiles:"
pp datafiles

## lint first (dry run - no database reads/updates/etc.)
SportDb.read( "#{SOURCE_DIR}/england", sync: false )
## SportDb.read( "#{SOURCE_DIR}/deutschland", sync: false )


## SportDb.read( "#{SOURCE_DIR}/england" )


SportDb.read( "#{SOURCE_DIR}/england/2015-16/.conf.txt" )
SportDb.read( "#{SOURCE_DIR}/england/2015-16/1-premierleague-i.txt" )
SportDb.read( "#{SOURCE_DIR}/england/2015-16/1-premierleague-ii.txt" )

## let's try another season
SportDb.read( "#{SOURCE_DIR}/england/2019-20/.conf.txt" )
SportDb.read( "#{SOURCE_DIR}/england/2019-20/1-premierleague.txt" )
