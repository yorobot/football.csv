# encoding: utf-8


task :bundesliga do |t|
  ## all bundesliga seasons in a single .csv file e.g.
  ##    Bundesliga_1963_2014.csv
  ##  assumes the following fields/header
  ##  - Spielzeit;Saison;Spieltag;Datum;Uhrzeit;Heim;Gast;Ergebnis;Halbzeit
  ##  e.g.
  ## 1;1963-1964;1;1963-08-24;17:00;Werder Bremen;Borussia Dortmund;3:2;1:1
  ## 1;1963-1964;1;1963-08-24;17:00;1. FC Saarbruecken;1. FC Koeln;0:2;0:2

  #
  # note: separator is semi-colon (e.g. ;)

  in_path = './dl/Bundesliga_1963_2014.csv'

  ## try a dry test run
##  i = 0
##  CSV.foreach( in_path, headers: true, col_sep: ';' ) do |row|
##    i += 1
##    print '.' if i % 100 == 0
##  end
##  puts " #{i} rows"

 ## out_root = './o'
 out_root = '../../footballcsv'

CsvMatchSplitter.split( in_path,
                        out_root: "#{out_root}/de-deutschland",
                        basename: '1-bundesliga',
                        format: 'long',
                        col_sep: ';',
                        headers: {
                            team1: 'Heim',
                            team2: 'Gast',
                            date:  'Datum',
                            score: 'Ergebnis',
                            scorei: 'Halbzeit',
                            round:  'Spieltag',
                            season: 'Saison',
                            } )


  ## update reports
  pack = CsvPackage.new( 'de-deutschland', path: out_root )

  summary_report = CsvSummaryReport.new( pack )
  summary_report.write
  ## note: write same as summary.save( "#{out_root}/SUMMARY.md" )

  standings_writer = CsvStandingsWriter.new( pack )
  standings_writer.write

  puts 'done'
end
