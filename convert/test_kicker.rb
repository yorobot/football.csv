# encoding: utf-8


## note: use the local version of sportdb-convert gem
$LOAD_PATH.unshift( File.expand_path( './sportdb-convert/lib') )

require 'sportdb/convert'


include KickerZine::Teams   ## add built-in team constants

pp ENG1_TEAMS_2019_20

pp DE1_TEAMS_2019_20

pp AT1_TEAMS_2019_20


def convert_eng
eng1      = '../kicker/eng.1.txt'
eng1_csv  = 'txt/o/eng.1.csv'
eng1_txt  = 'txt/o/eng/1-premierleague.txt'

## KickerZine.convert_to_csv( eng1, eng1_csv, teams: ENG1_TEAMS_2019_20, debug: true )

KickerZine.convert_to_txt( eng1, eng1_txt, teams: ENG1_TEAMS_2019_20,
                                title: 'English Premier League 2019/20',
                                round: 'Matchday',
                                lang: 'en',
                                debug: true )

end

def convert_de
de1     = '../kicker/de.1.txt'
de1_csv = 'txt/o/de.1.csv'
de1_txt = 'txt/o/de/1-bundesliga.txt'

de2     = '../kicker/de.2.txt'
de2_csv = 'txt/o/de.2.csv'
de2_txt = 'txt/o/de/2-bundesliga2.txt'

de3     = '../kicker/de.3.txt'
de3_csv = 'txt/o/de.3.csv'
de3_txt = 'txt/o/de/3-liga3.txt'


KickerZine.convert_to_txt( de1, de1_txt, teams: DE1_TEAMS_2019_20,
                                title: 'Deutsche Bundesliga 2019/20', round: 'Spieltag',
                                lang: 'de',
                                debug: true )

KickerZine.convert_to_txt( de2, de2_txt, teams: DE2_TEAMS_2019_20,
                                title: 'Deutsche 2. Bundesliga 2019/20', round: 'Spieltag',
                                lang: 'de',
                                debug: true )

KickerZine.convert_to_txt( de3, de3_txt, teams: DE3_TEAMS_2019_20,
                                title: 'Deutsche 3. Liga 2019/20', round: 'Spieltag',
                                lang: 'de',
                                debug: true )

end


def convert_at
at1      = '../kicker/at.1.txt'
at1_csv  = 'txt/o/at.1.csv'
at1_txt  = 'txt/o/at/1-bundesliga.txt'

at2      = '../kicker/at.2.txt'
at2_csv  = 'txt/o/at.2.csv'
at2_txt  = 'txt/o/at/2-liga1.txt'


## KickerZine.convert_to_csv( at1, at1_csv, teams: AT1_TEAMS_2018_19, debug: true )
## KickerZine.convert_to_csv( at2, at2_csv, teams: AT2_TEAMS_2018_19, debug: true )

KickerZine.convert_to_txt( at1, at1_txt, teams: AT1_TEAMS_2019_20,
                                title: 'Österr. Bundesliga 2019/20', round: 'Runde',
                                lang: 'de',
                                debug: true )

KickerZine.convert_to_txt( at2, at2_txt, teams: AT2_TEAMS_2019_20,
                                title: 'Österr. Erste Liga 2019/20', round: 'Runde',
                                lang: 'de',
                                debug: true )
end


def convert_es
es1      = '../kicker/es.1.txt'
es1_csv  = 'txt/o/es.1.csv'
es1_txt  = 'txt/o/es/1-liga.txt'

es2      = '../kicker/es.2.txt'
es2_csv  = 'txt/o/es.2.csv'
es2_txt  = 'txt/o/es/2-liga2.txt'

KickerZine.convert_to_txt( es1, es1_txt, teams: ES1_TEAMS_2019_20,
                                title: 'Primera División 2019/20',
                                round: 'Jornada',
                                lang: 'es',
                                debug: true )

KickerZine.convert_to_txt( es2, es2_txt, teams: ES2_TEAMS_2019_20,
                                title: 'Segunda División 2019/20',
                                round: 'Jornada',
                                lang: 'es',
                                debug: true )
end

def convert_it
it1      = '../kicker/it.1.txt'
it1_csv  = 'txt/o/it.1.csv'
it1_txt  = 'txt/o/it/1-seriea.txt'

KickerZine.convert_to_txt( it1, it1_txt, teams: IT1_TEAMS_2019_20,
                                title: 'Serie A 2019/20',
                                round: ->(round) { "%s^ Giornata" % round },
                                lang: 'it',
                                debug: true )
end




## convert_eng
## convert_de
## convert_at
## convert_es
convert_it
