# encoding: utf-8


require_relative 'lib/read'


## pp txt
## step 1: convert to csv

AT1_TEAMS_2018_19 = <<TXT
 Rapid Wien
 SCR Altach
 SV Mattersburg
 RB Salzburg
 FC Wacker Innsbruck
 Sturm Graz
 TSV Hartberg
 FC Admira Wacker
 LASK
 SKN St. Pölten
 Wolfsberger AC
 Austria Wien
TXT


AT2_TEAMS_2018_19 = <<TXT
  Vorwärts Steyr
  SV Ried
  Kapfenberger SV 1919
  Austria Wien (A)
  SC Wiener Neustadt
  FC Blau Weiß Linz
  SK Austria Klagenfurt
  Austria Lustenau
  SV Horn
  FC Liefering
  WSG Wattens
  SV Lafnitz
  SKU Amstetten
  Floridsdorfer AC
  LASK (A)
  FC Wacker Innsbruck (A)
TXT


DE1_TEAMS_2018_19 = <<TXT
  Bayern München
  1899 Hoffenheim
  Hertha BSC
  1. FC Nürnberg
  Werder Bremen
  Hannover 96
  SC Freiburg
  Eintracht Frankfurt
  VfL Wolfsburg
  FC Schalke 04
  Fortuna Düsseldorf
  FC Augsburg
  Bor. Mönchengladbach
  Bayer Leverkusen
  1. FSV Mainz 05
  VfB Stuttgart
  Borussia Dortmund
  RB Leipzig
TXT


DE2_TEAMS_2018_19 = <<TXT
  Hamburger SV
  Holstein Kiel
  VfL Bochum
  1. FC Köln
  Jahn Regensburg
  FC Ingolstadt 04
  SpVgg Greuther Fürth
  SV Sandhausen
  1. FC Magdeburg
  FC St. Pauli
  1. FC Union Berlin
  Erzgebirge Aue
  SV Darmstadt 98
  SC Paderborn 07
  1. FC Heidenheim 1846
  Arminia Bielefeld
  Dynamo Dresden
  MSV Duisburg
TXT



at1_path      = 'txt/at1_2018-19.txt'
at1_outpath   = 'txt/o/at1_2018-19.csv'
at1_txtpath   = 'txt/o/at/1-bundesliga.txt'

at2_path      = 'txt/at2_2018-19.txt'
at2_outpath   = 'txt/o/at2_2018-19.csv'
at2_txtpath   = 'txt/o/at/2-liga1.txt'


de1_path      = 'txt/de1_2018-19.txt'
de1_outpath   = 'txt/o/de1_2018-19.csv'
de1_txtpath   = 'txt/o/de/1-bundesliga.txt'


de2_path      = 'txt/de2_2018-19.txt'
de2_outpath   = 'txt/o/de2_2018-19.csv'
de2_txtpath   = 'txt/o/de/2-bundesliga2.txt'


## StandardNews.convert_to_csv( at1_path, at1_outpath, teams: AT1_TEAMS_2018_19, debug: true )
## StandardNews.convert_to_csv( at2_path, at2_outpath, teams: AT2_TEAMS_2018_19, debug: true )

## StandardNews.convert_to_csv( de1_path, de1_outpath, teams: DE1_TEAMS_2018_19, debug: true )
## StandardNews.convert_to_csv( de2_path, de2_outpath, teams: DE2_TEAMS_2018_19, debug: true )



TxtMatchWriter.write( at1_txtpath, StandardNews.read( at1_path, teams: AT1_TEAMS_2018_19 ),
                      title: 'Österr. Bundesliga 2018/19', round: 'Runde')

TxtMatchWriter.write( at2_txtpath, StandardNews.read( at2_path, teams: AT2_TEAMS_2018_19 ),
                      title: 'Österr. Erste Liga 2018/19', round: 'Runde')

TxtMatchWriter.write( de1_txtpath, StandardNews.read( de1_path, teams: DE1_TEAMS_2018_19 ),
                      title: 'Deutsche Bundesliga 2018/19', round: 'Spieltag')

TxtMatchWriter.write( de2_txtpath, StandardNews.read( de2_path, teams: DE2_TEAMS_2018_19 ),
                      title: 'Deutsche 2. Bundesliga 2018/19', round: 'Spieltag')
