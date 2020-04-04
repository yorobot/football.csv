require_relative 'boot'
require_relative 'repos'
require_relative 'git'


def sum( *country_keys )
  country_keys.each do |country_key|
    country_path    = COUNTRY_REPOS[country_key] || 'world'   ## note: if missing, fallback to world repo

    out_dir = "../../../footballcsv/#{country_path}"

    pack = CsvPackage.new( out_dir )

    # summary_report = CsvSummaryReport.new( pack )
    # summary_report.write


    buf = "# Clubs\n\n"
    buf << CsvTeamsReport.new( pack ).build
    File.open( "./tmp/CLUBS.md", 'w:utf-8' ) { |f| f.write buf }
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

sum( :tr )


puts "bye"