# encoding: utf-8


## note: use the local version of sportdb-convert gem
$LOAD_PATH.unshift( File.expand_path( './sportdb-convert/lib') )

require 'sportdb/convert'


include KickerZine::Teams   ## add built-in team constants

pp ENG1_TEAMS_2019_20

pp DE1_TEAMS_2019_20


def convert_eng
eng1      = '../kicker/eng.1.txt'
eng1_csv  = 'txt/o/eng.1.csv'
eng1_txt  = 'txt/o/1-premierleague.txt'

## KickerZine.convert_to_csv( eng1, eng1_csv, teams: ENG1_TEAMS_2019_20, debug: true )

KickerZine.convert_to_txt( eng1, eng1_txt, teams: ENG1_TEAMS_2019_20,
                                title: 'English Premier League 2019/20',
                                round: 'Matchday',
                                lang: 'en',
                                debug: true )

end

convert_eng
