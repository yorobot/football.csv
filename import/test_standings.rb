# encoding: utf-8



#####
# todo:  rename importer to import  (use sportdb-import) for (new) gem name !!!
#


require_relative 'lib/read'


###
# Country,League,Season,Date,Time,Home,Away,HG,AG,
#  Res,PH,PD,PA,MaxH,MaxD,MaxA,AvgH,AvgD,AvgA

matches_txt = CsvMatchReader.read( './dl/at-austria/AUT.csv',
                     filters: { 'Season' => '2017/2018' } )

pp matches_txt[0..2]


standings = SportDb::Struct::Standings.new
standings.update( matches_txt )

pp standings.to_a     ## note: to_a adds raking/sort by pos(ition)
