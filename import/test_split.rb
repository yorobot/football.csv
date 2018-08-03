# encoding: utf-8


require_relative 'lib/read'



eng_txt = './dl/engsoccerdata/data-test/england.csv'
###
#  "","Date","Season","home","visitor","FT","hgoal","vgoal","division","tier","totgoal","goaldif","result"
#  "1",1888-12-15,1888,"Accrington F.C.","Aston Villa","1-1",1,1,"1",1,2,0,"D"

CsvUtils.split( eng_txt, 'Season', 'division' )


##
#  Country,League,Season,Date,Time,Home,Away,HG,AG,Res,PH,PD,PA,MaxH,MaxD,MaxA,AvgH,AvgD,AvgA
#  Austria,Bundesliga,2016/2017,23/07/16,15:00,Rapid Vienna,Ried,5,0,H,1.37,5.05,10.11,1.45,5.05,10.11,1.38,4.55,8.11

at_txt = './dl/at-austria/AUT.csv'

CsvUtils.split( at_txt, 'Season' )


CsvUtils.split( at_txt, 'Season' ) do |values, chunk|
  puts "split on: "
  pp values
  headers = chunk.shift
  records = chunk
  puts headers.inspect
  puts "#{records.size} records"   ## remove header!!
end
