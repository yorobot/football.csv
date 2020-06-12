require_relative 'boot'
require_relative 'repos'



def sum( *country_keys )
  country_keys.each do |country_key|
    country_path    = COUNTRY_REPOS[country_key]
    fail "!! error - no repo found for country key #{country_key}"  if country_path.nil?

    out_dir = "../../../footballcsv/#{country_path}"

    pack = CsvPackage.new( out_dir )

    # summary_report = CsvSummaryReport.new( pack )
    # summary_report.write
    report = CsvPyramidReport.new( pack ) 
    
    buf = "# Summary\n\n"
    buf << report.build
    File.open( "./tmp/SUMMARY.md", 'w:utf-8' ) { |f| f.write buf }
  

    report = CsvTeamsReport.new( pack, country: country_key )

    buf = "# Clubs\n\n"
    buf << report.build
    File.open( "./tmp/CLUBS.md", 'w:utf-8' ) { |f| f.write buf }


    report_geo = TeamsByCityPart.new( report.team_mapping )
       
    buf = "# Clubs by Geo(graphy)\n\n"
    buf << report_geo.build
    File.open( "./tmp/CLUBS_GEO.md", 'w:utf-8' ) { |f| f.write buf }
   end
end  # method sum

=begin
[:eng, 
 :sco, 
 :de, 
 :it, 
 :es, 
 :fr,
 :nl,
 :be,
 :pt,
 :tr,
 :gr
 ]
=end

sum( :at )


puts "bye"