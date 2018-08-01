# encoding: utf-8

require './import/lib/read'


path = './dl/engsoccerdata/data-raw/champs.csv'

headers = {
##  team1:    'home',     team2:    'visitor',
  country1: 'hcountry', country2: 'vcountry',
  round:    'round',
  leg:      'leg',
  score:    'FT',
  season:   'Season',
  date:     'Date' }

CsvMatchReader.dump( path, headers: headers )


puts "\nOK. Done. Bye."
