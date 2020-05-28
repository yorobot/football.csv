SPORTDB_DIR      = '../../../sportdb'     # path to libs

## note: use the local version of sportdb gems
$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_DIR}/sport.db/date-formats/lib" ))

$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_DIR}/sport.db/sportdb-formats/lib" ))

# $LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_DIR}/football.db/footballdb-leagues/lib" ))
# $LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_DIR}/football.db/footballdb-clubs/lib" ))

$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_DIR}/sport.db/sportdb-config/lib" ))
$LOAD_PATH.unshift( File.expand_path( "../sportdb-linters/lib" ))


require 'sportdb/linters'




OPENFOOTBALL_DIR   = '../../../openfootball'         # path to datasets

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{OPENFOOTBALL_DIR}/clubs"
SportDb::Import.config.leagues_dir = "#{OPENFOOTBALL_DIR}/leagues"

