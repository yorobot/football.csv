# encoding: utf-8


require_relative 'lib/read'


de_txt = './dl/Bundesliga_1963_2014.csv'

at_txt = './dl/at-austria/AUT.csv'
mx_txt = './dl/mx-mexico/MEX.csv'
br_txt = './dl/br-brazil/BRA.csv'          # note: uses years (e.g. 2014) for seasons
us_txt = './dl/us-united_states/USA.csv'   # note: uses years (e.g. 2014) for seasons

root = './o'
## root = '../../footballcsv'


if ARGV.include?( 'de' )

=begin
Spielzeit;Saison;Spieltag;Datum;Uhrzeit;Heim;Gast;Ergebnis;Halbzeit
1;1963-1964;1;1963-08-24;17:00;Werder Bremen;Borussia Dortmund;3:2;1:1
=end

  CsvMatchSplitter.split( de_txt,
                          out_root: "#{root}/de-deutschland2",
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
end



if ARGV.include?( 'at' )
  CsvMatchSplitter.split( at_txt,
                          out_root: "#{root}/at-austria",
                          basename: '1-bundesliga',
                          format: 'long' )

  at_pack = CsvPackage.new( 'at-austria', path: root )
  at_summary_report = CsvSummaryReport.new( at_pack )
  at_summary_report.write
end

if ARGV.include?( 'mx' )
  split_seasons( mx_txt, out_root: "#{root}/mx-mexico",  basename: '1-liga' )

  mx_pack = CsvPackage.new( 'mx-mexico', path: root )
  mx_summary_report = CsvSummaryReport.new( mx_pack )
  mx_summary_report.write
end

if ARGV.include?( 'us' )
  split_seasons( us_txt, out_root: "#{root}/major-league-soccer",  basename: '1-league' )

  us_pack = CsvPackage.new( 'major-league-soccer', path: root )
  us_summary_report = CsvSummaryReport.new( us_pack )
  us_summary_report.write
end

if ARGV.include?( 'br' )
  split_seasons( br_txt, out_root: "#{root}/br-brazil",  basename: '1-seriea' )

  br_pack = CsvPackage.new( 'br-brazil', path: root )
  br_summary_report = CsvSummaryReport.new( br_pack )
  br_summary_report.write
end
