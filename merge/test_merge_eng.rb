# encoding: utf-8

require_relative 'merge'


## "","Date","Season","home","visitor","FT","hgoal","vgoal",
#   "division","tier",
#   "totgoal","goaldif","result"

# "1",1888-12-15,1888,"Accrington F.C.","Aston Villa","1-1",1,1,
#   "1",1,
#   2,0,"D"


eng = CsvMatchUpdates.new( '../eng-england' )
## pp eng.find_by_season_n_division( '2013-2014', '1' )

path = './dl/engsoccerdata/data-raw/england.csv'

headers = {
    team1:  'home',
    team2:  'visitor',
    date:   'Date',
    score:  'FT',
    season: 'Season',
    level:  'tier',
    ## division: 'division',   ## add/use division from source
    }


## 1993-94
eng.check( path, headers, start: '1993-94', level: 1 ) do |h|
  h[:season]    = "%4d-%02d" % [h[:season].to_i, (h[:season].to_i+1) % 100]    ## fix season format
  h[:division]  = '1'
end
pp eng.errors
pp eng.count
