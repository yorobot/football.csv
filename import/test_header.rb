# encoding: utf-8


require_relative 'lib/read'


##
#  Div,Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR,HTHG,HTAG,HTR,Referee,HS,AS,HST,AST,HF,AF,HC,AC,HY,AY,HR,AR,B365H,B365D,B365A,BWH,BWD,BWA,IWH,IWD,IWA,LBH,LBD,LBA,PSH,PSD,PSA,WHH,WHD,WHA,VCH,VCD,VCA,Bb1X2,BbMxH,BbAvH,BbMxD,BbAvD,BbMxA,BbAvA,BbOU,BbMx>2.5,BbAv>2.5,BbMx<2.5,BbAv<2.5,BbAH,BbAHh,BbMxAHH,BbAvAHH,BbMxAHA,BbAvAHA,PSCH,PSCD,PSCA
#  E0,11/08/17,Arsenal,Leicester,4,3,H,2,2,D,M Dean,27,6,10,3,9,12,9,4,0,1,0,0,1.53,4.5,6.5,1.5,4.6,6.75,1.47,4.5,6.5,1.44,4.4,6.5,1.53,4.55,6.85,1.53,4.2,6,1.53,4.5,6.5,41,1.55,1.51,4.6,4.43,6.89,6.44,37,1.65,1.61,2.43,2.32,21,-1,1.91,1.85,2.1,2.02,1.49,4.73,7.25

eng_txt = './dl/eng-england/2017-18/E0.csv'

pp CsvUtils.header( eng_txt )


at_txt = './dl/at-austria/AUT.csv'

pp CsvUtils.header( at_txt )
