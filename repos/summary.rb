require_relative 'boot'
require_relative 'repos'
require_relative 'git'



def sum( path, country: nil )
    out_dir = path

    git_pull( out_dir )
    print "hit return to continue: ";  ch=STDIN.getc

    pack = CsvPackage.new( out_dir )


    report = CsvPyramidReport.new( pack ) 
    
    buf = "# Summary\n\n"
    buf << report.build
    File.open( "#{out_dir}/SUMMARY.md", 'w:utf-8' ) { |f| f.write buf }
  

    report = CsvTeamsReport.new( pack, country: country )

    buf = "# Clubs\n\n"
    buf << report.build
    File.open( "#{out_dir}/CLUBS.md", 'w:utf-8' ) { |f| f.write buf }


    report_geo = TeamsByCityPart.new( report.team_mapping )
       
    buf = "# Clubs by Geo(graphy)\n\n"
    buf << report_geo.build
    File.open( "#{out_dir}/CLUBS_GEO.md", 'w:utf-8' ) { |f| f.write buf }


    print "hit return to commit: ";  ch=STDIN.getc
    git_commit( out_dir )
end  # method sum


=begin
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
]
=end


=begin
COUNTRY_REPOS.each do |country_key, country_path|
  ## filter by country code
  ## next   unless [:mx].include?( country_key )
  
  path = "../../../footballcsv/#{country_path}"
  sum( path, country: country_key.to_s )
end
=end


### extras
sum( "../../../footballcsv/major-league-soccer", country: 'us' )
# sum( "../../../footballcsv/europe-champions-league"  )

