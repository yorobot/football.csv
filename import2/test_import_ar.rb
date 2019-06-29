# encoding: utf-8

require 'sportdb/text'

SportDb::Import.config.clubs_dir = '../../openfootball/clubs'

## test import Argentina (ARG), ar

##
## Country,League,Season,Date,Time,Home,Away,HG,AG,Res
##       ,PH,PD,PA,MaxH,MaxD,MaxA,AvgH,AvgD,AvgA
##
## Argentina,Primera Division ,2012/2013,03/08/2012,23:00,Arsenal Sarandi,Union de Santa Fe,
##   1,0,H,1.9,3.39,5.03,1.9,3.5,5.68,1.76,3.3,4.74
## Argentina,Primera Division ,2012/2013,04/08/2012,01:10,Velez Sarsfield,Argentinos Jrs,
##   3,0,H,2,3.24,4.55,2.18,3.3,4.62,1.97,3.12,3.96

##
## todo/fix: add ARG season sample to  sportdb-text spliter!!!!
##    has one-year and two-year seasons!!!!
=begin
{"2012/2013"=>381,
 "2013/2014"=>383,
 "2014"=>190,
 "2015"=>468,
 "2016"=>242,
 "2016/2017"=>450,
 "2017/2018"=>378,
 "2018/2019"=>324}
=end


path = './dl/ARG.csv'
col  = 'Season'

seasons = CsvMatchSplitter.find_seasons( path, col: col )
pp seasons


=begin
CsvMatchSplitter.split( path,
                        out_root: './o/ar-argentina',
                        basename: '1-liga',
                        format: 'long',
                        headers: {
                            team1: 'Heim',
                            team2: 'Gast',
                            date:  'Datum',
                            score: 'Ergebnis',
                            scorei: 'Halbzeit',
                            round:  'Spieltag',
                            season: 'Saison',
                            } )
=end

headers = {
  team1: 'Home',
  team2: 'Away',
  date:  'Date',
  score1: 'HG',
  score2: 'AG',
  ## season: 'Season',   ## check if season required / needed???
}


seasons.each do |season|
      matches = CsvMatchReader.read( path,
        headers: headers, filters: { col => season } )

      pp matches[0..2]
      pp matches.size

      out_path = "./o/argentina/#{SeasonUtils.directory(season)}/ar.1.csv"
      ## make sure parent folders exist
      FileUtils.mkdir_p( File.dirname(out_path) )  unless Dir.exists?( File.dirname( out_path ))

      CsvMatchWriter.write( out_path, matches )

      ###
      ## todo: fix!!!  allow convert date/time in .csv !!!!
      ##   for mx-mexico (assume utc and convert to local time e.g. -6 hours or something!!)
      ##      will change 1:00 to one day back!!!!
end
