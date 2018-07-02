# encoding: utf-8



require_relative 'lib/read'


repo = 'be-belgium'

pack = CsvPackage.new( 'be-belgium', path: './o' )
season_entries = pack.find_entries_by_season


pp pack.expand_path( '1999-00' )
pp pack.expand_path( '2000-01/1-bundesliga.csv' )

pp season_entry  = season_entries[0]
pp season_dir    = season_entry[0]
pp season_files  = season_entry[1]

pp pack.expand_path( season_files[0] )



## puts build_summary_report( 'be-belgium', path: './o' )
puts build_teams_report( 'be-belgium', path: './o' )

## puts build_summary_report( 'fr-france', path: './o' )
## puts build_teams_report( 'fr-france', path: './o' )
