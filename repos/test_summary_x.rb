require_relative 'boot'


def sum( path, country: nil )
    out_dir = path

    pack = CsvPackage.new( out_dir )

    # summary_report = CsvSummaryReport.new( pack )
    # summary_report.write
    report = CsvPyramidReport.new( pack ) 
    
    buf = "# Summary\n\n"
    buf << report.build
    File.open( "./tmp/SUMMARY.md", 'w:utf-8' ) { |f| f.write buf }
  

    report = CsvTeamsReport.new( pack, country: country )

    buf = "# Clubs\n\n"
    buf << report.build
    File.open( "./tmp/CLUBS.md", 'w:utf-8' ) { |f| f.write buf }
end  # method sum


path = "../../../footballcsv/europe-champions-league"
sum( path )

# path = "../../../footballcsv/major-league-soccer"
# sum( path, country: 'us' )


puts "bye"