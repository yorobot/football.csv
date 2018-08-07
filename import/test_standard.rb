# encoding: utf-8


require_relative 'lib/read'



at1      = 'txt/at1_2018-19.txt'
at1_csv  = 'txt/o/at1_2018-19.csv'
at1_txt  = 'txt/o/at/1-bundesliga.txt'

at2      = 'txt/at2_2018-19.txt'
at2_csv  = 'txt/o/at2_2018-19.csv'
at2_txt  = 'txt/o/at/2-liga1.txt'

include StandardNews::Teams   ## add built-in team constants

## StandardNews.convert_to_csv( at1, at1_csv, teams: AT1_TEAMS_2018_19, debug: true )
## StandardNews.convert_to_csv( at2, at2_csv, teams: AT2_TEAMS_2018_19, debug: true )

StandardNews.convert_to_txt( at1, at1_txt, teams: AT1_TEAMS_2018_19,
                                title: 'Österr. Bundesliga 2018/19', round: 'Runde')

StandardNews.convert_to_txt( at2, at2_txt, teams: AT2_TEAMS_2018_19,
                                title: 'Österr. Erste Liga 2018/19', round: 'Runde')


de1     = 'txt/de1_2018-19.txt'
de1_csv = 'txt/o/de1_2018-19.csv'
de1_txt = 'txt/o/de/1-bundesliga.txt'

de2     = 'txt/de2_2018-19.txt'
de2_csv = 'txt/o/de2_2018-19.csv'
de2_txt = 'txt/o/de/2-bundesliga2.txt'

## StandardNews.convert_to_csv( de1, de1_csv, teams: DE1_TEAMS_2018_19, debug: true )
## StandardNews.convert_to_csv( de2, de2_csv, teams: DE2_TEAMS_2018_19, debug: true )

StandardNews.convert_to_txt( de1, de1_txt, teams: DE1_TEAMS_2018_19,
                                title: 'Deutsche Bundesliga 2018/19', round: 'Spieltag')

StandardNews.convert_to_txt( de2, de2_txt, teams: DE2_TEAMS_2018_19,
                                title: 'Deutsche 2. Bundesliga 2018/19', round: 'Spieltag')
