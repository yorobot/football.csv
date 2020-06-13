## note: use the local version of sportdb-source gem
$LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/sportdb-formats/lib') )
$LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/sportdb-importers/lib') )

require 'sportdb/importers'

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"
SportDb::Import.config.leagues_dir = "../../../openfootball/leagues"

