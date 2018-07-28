# encoding: utf-8


require_relative 'lib/read'

root = './o'
## root = '../../footballcsv'

report = CsvSummaryReport.new( "#{root}/eng-england3" )
report.write     ## will write to "./SUMMARY.md"
