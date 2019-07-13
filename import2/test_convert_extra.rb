# encoding: utf-8

require 'sportdb/text'

SportDb::Import.config.clubs_dir = '../../openfootball/clubs'

## test import Japan, jp

## Country,League,Season,Date,Time,Home,Away,HG,AG,Res
##        ,PH,PD,PA,MaxH,MaxD,MaxA,AvgH,AvgD,AvgA
## Japan,J-League,2012,10/03/2012,05:00,G-Osaka,Kobe,
##     2,3,A,1.94,3.56,4.34,1.94,4,5.5,1.71,3.62,4.55
## Japan,J-League,2012,10/03/2012,05:00,Hiroshima,Urawa,
##     1,0,H,2.83,3.42,2.63,2.83,3.42,3,2.51,3.19,2.67



def split( path, out_dir, country )
col  = 'Season'

seasons = CsvMatchSplitter.find_seasons( path, col: col )
pp seasons


headers = {
  team1: 'Home',
  team2: 'Away',
  date:  'Date',
  score1: 'HG',
  score2: 'AG',
}


seasons.each do |season|
      matches = CsvMatchReader.read( path,
        headers: headers, filters: { col => season } )

      pp matches[0..2]
      pp matches.size

      out_path = "#{out_dir}/#{SeasonUtils.directory(season)}/#{country}.1.csv"
      ## make sure parent folders exist
      FileUtils.mkdir_p( File.dirname(out_path) )  unless Dir.exists?( File.dirname( out_path ))

      CsvMatchWriter.write( out_path, matches )

      ###
      ## todo: fix!!!  allow convert date/time in .csv !!!!
      ##   for mx-mexico (assume utc and convert to local time e.g. -6 hours or something!!)
      ##      will change 1:00 to one day back!!!!
end
end

datafiles = [
  ['ar', 'ARG', 'argentina'],
  ## ['at', 'AUT', 'austria'],
  ['br', 'BRA', 'brazil'],
  ['cn', 'CHN', 'china'],
  ['dk', 'DNK', 'denmark'],
  ['fi', 'FIN', 'finland'],
  ['ie', 'IRL', 'ireland'],
  ['jp', 'JPN', 'japan'],
  ## ['mx', 'MEX', 'mexico'],
  ['no', 'NOR', 'norway'],
  ['pl', 'POL', 'poland'],
  ['ro', 'ROU', 'romania'],
  ['ru', 'RUS', 'russia'],
  ['se', 'SWE', 'sweden'],
  ['ch', 'SWZ', 'switzerland'],
  ## ['us', 'USA', 'usa']
].each do |item|
  country = item[0]
  path    = "./dl/#{item[1]}.csv"
  ## out_dir = "./oo/#{item[2]}"
  out_dir = "../../footballcsv/world"

  split( path, out_dir, country )

=begin
  pack = CsvPackage.new( out_dir )
  report = CsvTeamsReport.new( pack )
  ## txt = report.build
  ## puts txt
  report.save( "./oo/TEAMS.#{country}.md" )
=end
end
