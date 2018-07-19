# encoding: utf-8


require_relative 'lib/read'


root_path = "./dl/test-levels2"

## check should NOT include /1980s  (with s)  only /1980 /1981 etc.

season_patterns = [
     '[0-9][0-9][0-9][0-9]-[0-9][0-9]',  ## e.g. /1998-99/
     '[0-9][0-9][0-9][0-9]'              ## e.g  /1999/  - note: will NOT include /1990s etc.
]


season_paths = Dir.glob( "#{root_path}/**/{#{season_patterns.join(',')}}" )

pp season_paths


pack = CsvPackage.new( 'test-levels2', path: './dl' )

pp pack.find_entries_by_season
