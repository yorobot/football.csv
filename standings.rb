require 'sportdb/text'




pack = CsvPackage.new( "../../footballcsv/turkey" )

### todo:
## use all-in-one   pack.update_reports - why? why not?

# summary_report = CsvSummaryReport.new( pack )
# summary_report.write
## note: write same as summary.save( "#{out_root}/SUMMARY.md" )

standings_writer = CsvStandingsWriter.new( pack )
standings_writer.write
