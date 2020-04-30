SPORTDB_PATH = '../../../sportdb/sport.db'

## note: use the local version of sportdb gems
$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_PATH}/sportdb-formats/lib" ))
$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_PATH}/sportdb-countries/lib" ))
$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_PATH}/sportdb-leagues/lib" ))
$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_PATH}/sportdb-teams/lib" ))

$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_PATH}/footballdb-leagues/lib" ))
$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_PATH}/footballdb-clubs/lib" ))

$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_PATH}/sportdb-match-formats/lib" ))
$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_PATH}/sportdb-config/lib" ))



require 'sportdb/config'


OPENFOOTBALL_PATH = '../../../openfootball'

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{OPENFOOTBALL_PATH}/clubs"
SportDb::Import.config.leagues_dir = "#{OPENFOOTBALL_PATH}/leagues"

### "pre-load" leagues & clubs
COUNTRIES      = SportDb::Import.catalog.countries
LEAGUES        = SportDb::Import.catalog.leagues
CLUBS          = SportDb::Import.catalog.clubs
NATIONAL_TEAMS = SportDb::Import.catalog.national_teams
