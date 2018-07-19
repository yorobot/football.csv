# encoding: utf-8


require_relative 'lib/read'


root = './dl'

pack = CsvPackage.new( 'test-levels', path: root )
report = CsvSummaryReport.new( pack )
report.write
