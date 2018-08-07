

require_relative 'lib/read'


eng_csv = './dl/eng-england/2017-18/E0.csv'
at_csv = './dl/at-austria/AUT.csv'


## CsvTool.header( ['--help'] )
CsvTool.header( [eng_csv] )
CsvTool.header( [at_csv] )
CsvTool.header( [at_csv, eng_csv] )
CsvTool.header( [] )

CsvTool.stat( ["--column=Div,HomeTeam,AwayTeam", eng_csv] )
CsvTool.stat( ["-c=Div,HomeTeam,AwayTeam", eng_csv] )

CsvTool.stat( ["--column=Season,Home,Away", at_csv] )

CsvTool.head( [at_csv] )
CsvTool.head( ["-n2", at_csv] )
