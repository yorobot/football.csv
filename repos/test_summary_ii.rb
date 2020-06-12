require_relative 'boot'
require_relative 'repos'



def sum( *country_keys )
  country_keys.each do |country_key|
    country_path    =  'world' 

    out_dir = "../../../footballcsv/#{country_path}"

    pack = CsvPackage.new( out_dir, filter: country_key.to_s )

    # summary_report = CsvSummaryReport.new( pack )
    # summary_report.write
    report = CsvPyramidReport.new( pack ) 
    
    buf = "# Summary\n\n"
    buf << report.build
    File.open( "./tmp/#{country_key}.SUMMARY.md", 'w:utf-8' ) { |f| f.write buf }
  

    report = CsvTeamsReport.new( pack, country: country_key )

    buf = "# Clubs\n\n"
    buf << report.build
    File.open( "./tmp/#{country_key}.CLUBS.md", 'w:utf-8' ) { |f| f.write buf }


    report_geo = TeamsByCityPart.new( report.team_mapping )
       
    buf = "# Clubs by Geo(graphy)\n\n"
    buf << report_geo.build
    File.open( "./tmp/#{country_key}.CLUBS_GEO.md", 'w:utf-8' ) { |f| f.write buf }
   end
end  # method sum

=begin
[:br, 
 :ar, 
 ]
=end

sum( :ar )


puts "bye"
