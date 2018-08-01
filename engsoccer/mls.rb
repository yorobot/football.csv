# encoding: utf-8

require './import/lib/read'


path = './dl/engsoccerdata/data-raw/mls.csv'

headers = { team1:  'home',  team2: 'visitor',
            conf1:  'hconf', conf2: 'vconf',
            score:  'FT',
            season: 'Season',
            date:   'Date',
            round:  'round',
            leg:    'leg'  }

CsvMatchReader.dump( path, headers: headers )


puts "\nOK. Done. Bye."
