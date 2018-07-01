# encoding: utf-8



#####
# todo:  rename importer to import  (use sportdb-import) for (new) gem name !!!
#


require_relative 'lib/read'


##
# Div,Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR,HTHG,HTAG,HTR,
#   Referee,HS,AS,HST,AST,HF,AF,HC,AC,HY,AY,HR,AR,
#    B365H,B365D,B365A,BWH,BWD,BWA,IWH,IWD,IWA,LBH,LBD,LBA,PSH,PSD,PSA,
#    WHH,WHD,WHA,VCH,VCD,VCA,
#    Bb1X2,BbMxH,BbAvH,BbMxD,BbAvD,BbMxA,BbAvA,BbOU,BbMx>2.5,BbAv>2.5,BbMx<2.5,BbAv<2.5,
#    BbAH,BbAHh,BbMxAHH,BbAvAHH,BbMxAHA,BbAvAHA,PSCH,PSCD,PSCA

matches_txt = CsvMatchReader.read( './dl/eng-england/2017-18/E0.csv',
                     filters: { 'HomeTeam' => 'Arsenal' } )

pp matches_txt[0..2]


matches_txt = CsvMatchReader.read( './dl/eng-england/2017-18/E0.csv',
                     headers: { team1:  'HomeTeam',
                                team2:  'AwayTeam',
                                date:   'Date',
                                score1: 'FTHG',
                                score2: 'FTAG' } )

pp matches_txt[0..2]


###
# Country,League,Season,Date,Time,Home,Away,HG,AG,
#  Res,PH,PD,PA,MaxH,MaxD,MaxA,AvgH,AvgD,AvgA

matches_txt = CsvMatchReader.read( './dl/at-austria/AUT.csv',
                     filters: { 'Season' => '2017/2018' } )

pp matches_txt[0..2]
