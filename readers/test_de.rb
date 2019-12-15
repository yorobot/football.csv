require_relative 'build'


### "pre-load" leagues & clubs
LEAGUES = SportDb::Import.config.leagues
CLUBS   = SportDb::Import.config.clubs


setup( 'deutschland' )
## read( 'deutschland', season: '2019/20' )
read( 'deutschland' )



__END__
SportDb.lang.lang = 'de'
DateFormats.lang  = 'de'

de_path = "#{SOURCE_DIR}/deutschland"
pack = SportDb::DirPackage.new( de_path )

pack.read_match( '2016-17/3-liga3-i.txt' )
