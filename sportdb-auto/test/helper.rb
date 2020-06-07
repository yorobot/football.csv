## note: use the local version of sportdb gems
$LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/sportdb-formats/lib' ))


## minitest setup
require 'minitest/autorun'


## our own code
require 'sportdb/auto'


LEAGUES = SportDb::Import.catalog.leagues
CLUBS   = SportDb::Import.catalog.clubs
