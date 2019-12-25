require_relative 'build'


### "pre-load" leagues & clubs
LEAGUES = SportDb::Import.config.leagues
CLUBS   = SportDb::Import.config.clubs


setup( 'espana' )
read( 'espana' )
