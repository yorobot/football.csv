# encoding: utf-8


require_relative 'lib/read'


de_txt = './dl/Bundesliga_1963_2014.csv'

root = './o'
## root = '../../footballcsv'


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


de_pack = CsvPackage.new( 'de-deutschland2', path: root )
de_report = CsvSummaryReport.new( de_pack )
de_report.write
