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



=begin
be = CsvPackage.new( 'be-belgium', path: './o' )

be_seasons = SeasonsReport.new( be )
puts be_seasons.build_summary
be_seasons.save( './o/be_seasons.txt' )

be_teams = TeamsReport.new( be )
puts be_teams.build_summary
be_teams.save( './o/be_teams.txt' )

be_summary = SummaryReport.new( be )
puts be_summary.build_summary
be_summary.save( './o/be_summary.txt' )
=end

tr = CsvPackage.new( 'tr-turkey', path: './o' )

tr_summary = CsvSummaryReport.new( tr )
puts tr_summary.build_summary
tr_summary.save( './o/tr_summary.txt' )



## puts build_summary_report( 'be-belgium', path: './o' )
## puts build_teams_report( 'be-belgium', path: './o' )

## puts build_summary_report( 'fr-france', path: './o' )
## puts build_teams_report( 'fr-france', path: './o' )
