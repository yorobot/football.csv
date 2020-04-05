## note: use the local version of sportdb-source gem
$LOAD_PATH.unshift( File.expand_path( '../sportdb-source-footballdata/lib') )
$LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/sportdb-formats/lib') )
$LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/sportdb-text/lib') )

require 'sportdb/source/footballdata'

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"
SportDb::Import.config.leagues_dir = "../../../openfootball/leagues"
