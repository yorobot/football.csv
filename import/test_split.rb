# encoding: utf-8


require_relative 'lib/read'





def split_seasons( path, out_root: './o', basename: '1-liga' )
  seasons = find_seasons_in_txt( path )
  pp seasons

=begin
## AUT.csv
{"2012/2013"=>180,
 "2013/2014"=>180,
 "2014/2015"=>180,
 "2015/2016"=>180,
 "2016/2017"=>180,
 "2017/2018"=>182}

## MEX.csv
{"2012/2013"=>334,
 "2013/2014"=>334,
 "2014/2015"=>334,
 "2015/2016"=>334,
 "2016/2017"=>334,
 "2017/2018"=>332}
=end

  seasons.each do |season|
      matches = CsvMatchReader.read( path, filters: { 'Season' => season } )

      pp matches[0..2]
      pp matches.size

      out_path = "#{out_root}/#{SeasonUtils.directory(season)}/#{basename}.csv"
      ## make sure parent folders exist
      FileUtils.mkdir_p( File.dirname(out_path) )  unless Dir.exists?( File.dirname( out_path ))

      CsvMatchWriter.write( out_path, matches )

      ###
      ## todo: fix!!!  allow convert date/time in .csv !!!!
      ##   for mx-mexico (assume utc and convert to local time e.g. -6 hours or something!!)
      ##      will change 1:00 to one day back!!!!
  end
end



at_txt = './dl/at-austria/AUT.csv'
mx_txt = './dl/mx-mexico/MEX.csv'
br_txt = './dl/br-brazil/BRA.csv'          # note: uses years (e.g. 2014) for seasons
us_txt = './dl/us-united_states/USA.csv'   # note: uses years (e.g. 2014) for seasons

root = './o'
## root = '../../footballcsv'


if ARGV.include?( 'at' )
  split_seasons( at_txt, out_root: "#{root}/at-austria", basename: '1-bundesliga' )

  at_pack = CsvPackage.new( 'at-austria', path: root )
  at_summary_report = CsvSummaryReport.new( at_pack )
  at_summary_report.write
end

if ARGV.include?( 'mx' )
  split_seasons( mx_txt, out_root: "#{root}/mx-mexico",  basename: '1-liga' )

  mx_pack = CsvPackage.new( 'mx-mexico', path: root )
  mx_summary_report = CsvSummaryReport.new( mx_pack )
  mx_summary_report.write
end

if ARGV.include?( 'us' )
  split_seasons( us_txt, out_root: "#{root}/major-league-soccer",  basename: '1-league' )

  us_pack = CsvPackage.new( 'major-league-soccer', path: root )
  us_summary_report = CsvSummaryReport.new( us_pack )
  us_summary_report.write
end

if ARGV.include?( 'br' )
  split_seasons( br_txt, out_root: "#{root}/br-brazil",  basename: '1-seriea' )

  br_pack = CsvPackage.new( 'br-brazil', path: root )
  br_summary_report = CsvSummaryReport.new( br_pack )
  br_summary_report.write
end
