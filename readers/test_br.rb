require_relative 'build'


### "pre-load" leagues & clubs
LEAGUES = SportDb::Import.config.leagues
CLUBS   = SportDb::Import.config.clubs


setup( 'brazil' )
read( 'brazil' )   ### todo/fix:  check regex for seasons for matching years only e.g. 2014 etc.
