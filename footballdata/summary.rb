require_relative 'boot'
require_relative 'repos'
require_relative 'git'


def sum( *country_keys )
  country_keys.each do |country_key|
    country_path    = COUNTRY_REPOS[country_key]

    out_dir = "../../../footballcsv/#{country_path}"

    git_pull( out_dir )
    print "hit return to continue: ";  ch=STDIN.getc

    pack = CsvPackage.new( out_dir )

    # summary_report = CsvSummaryReport.new( pack )
    # summary_report.write

    report = CsvPyramidReport.new( pack ) 
    
    buf = "# Summary\n\n"
    buf << report.build
    File.open( "#{out_dir}/SUMMARY.md", 'w:utf-8' ) { |f| f.write buf }
  

    report = CsvTeamsReport.new( pack, country: country_key )

    buf = "# Clubs\n\n"
    buf << report.build
    File.open( "#{out_dir}/CLUBS.md", 'w:utf-8' ) { |f| f.write buf }


    report_geo = TeamsByCityPart.new( report.team_mapping )
       
    buf = "# Clubs by Geo(graphy)\n\n"
    buf << report_geo.build
    File.open( "#{out_dir}/CLUBS_GEO.md", 'w:utf-8' ) { |f| f.write buf }


    print "hit return to commit: ";  ch=STDIN.getc
    git_commit( out_dir )
  end
end  # method sum


[
# :eng, 
# :sco, 
# :de, 
# :it, 
 :es, 
 :fr,
 :nl,
 :be,
 :pt,
 :tr,
 :gr
].each do |country_key|
   sum( country_key )
end

# sum( :tr )


