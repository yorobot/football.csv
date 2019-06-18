# encoding: utf-8

require_relative 'merge'

## all bundesliga seasons in a single .csv file e.g.
##    Bundesliga_1963_2014.csv
##  assumes the following fields/header
##  - Spielzeit;Saison;Spieltag;Datum;Uhrzeit;Heim;Gast;Ergebnis;Halbzeit
##  e.g.
## 1;1963-1964;1;1963-08-24;17:00;Werder Bremen;Borussia Dortmund;3:2;1:1
## 1;1963-1964;1;1963-08-24;17:00;1. FC Saarbruecken;1. FC Koeln;0:2;0:2



de = CsvMatchUpdates.new( '../de-deutschland' )
## pp de.find_by_season_n_division( '2013-2014', '1' )


path = './dl/Bundesliga_1963_2014.csv'


headers = {
    team1:  'Heim',
    team2:  'Gast',
    date:   'Datum',
    score:  'Ergebnis',
    scorei: 'Halbzeit',
    round:  'Spieltag',
    season: 'Saison',
    }


## 1993-94
de.check( path, headers, start: '1993-94', sep: ';' ) do |h|
  h[:division] = '1'
end
pp de.errors
pp de.count

## de.write    ## write back all (cached) match changes/updates
