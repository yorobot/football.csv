# encoding: utf-8


require_relative 'lib/read'

root = './o'
## root = '../../footballcsv'

pack = CsvPackage.new( "#{root}/eng-england3" )
pp pack.find_entries_by_season

report = CsvSummaryReport.new( pack )
report.write
