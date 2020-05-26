SPORTDB_DIR      = '../../../sportdb'     # path to libs

## note: use the local version of sportdb gems
$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_DIR}/sport.db/date-formats/lib" ))

$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_DIR}/sport.db/sportdb-formats/lib" ))

# $LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_DIR}/football.db/footballdb-leagues/lib" ))
# $LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_DIR}/football.db/footballdb-clubs/lib" ))

$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_DIR}/sport.db/sportdb-config/lib" ))


require 'sportdb/config'




OPENFOOTBALL_DIR   = '../../../openfootball'         # path to datasets

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{OPENFOOTBALL_DIR}/clubs"
SportDb::Import.config.leagues_dir = "#{OPENFOOTBALL_DIR}/leagues"

### "pre-load" leagues & clubs
COUNTRIES      = SportDb::Import.catalog.countries
LEAGUES        = SportDb::Import.catalog.leagues
CLUBS          = SportDb::Import.catalog.clubs
NATIONAL_TEAMS = SportDb::Import.catalog.national_teams
TEAMS          = SportDb::Import.catalog.teams
