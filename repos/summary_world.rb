require_relative 'boot'
require_relative 'repos'
require_relative 'git'


def sum( *country_keys )

  country_path    = 'world' 

  out_dir = "../../../footballcsv/#{country_path}"

  git_pull( out_dir )
  print "hit return to continue: ";  ch=STDIN.getc


  country_keys.each do |country_key|
  
    pack = CsvPackage.new( out_dir, filter: country_key.to_s )

    # summary_report = CsvSummaryReport.new( pack )
    # summary_report.write

    report = CsvPyramidReport.new( pack ) 
    
    buf = "# Summary\n\n"
    buf << report.build
    File.open( "#{out_dir}/#{country_key}.SUMMARY.md", 'w:utf-8' ) { |f| f.write buf }
  

    report = CsvTeamsReport.new( pack, country: country_key )

    buf = "# Clubs\n\n"
    buf << report.build
    File.open( "#{out_dir}/#{country_key}.CLUBS.md", 'w:utf-8' ) { |f| f.write buf }


    report_geo = TeamsByCityPart.new( report.team_mapping )
       
    buf = "# Clubs by Geo(graphy)\n\n"
    buf << report_geo.build
    File.open( "#{out_dir}/#{country_key}.CLUBS_GEO.md", 'w:utf-8' ) { |f| f.write buf }
  end

  print "hit return to commit: ";  ch=STDIN.getc
  git_commit( out_dir )
end  # method sum


country_keys = [
 :ar, 
 :br,
 
 :cn,
 :jp,

 :fi,
 :no,
 :se,
 :dk,
 :ie,
 :ch,
 :pl,
 :ro,
 :ru,
] 
sum( *country_keys )

# sum( :ar )


