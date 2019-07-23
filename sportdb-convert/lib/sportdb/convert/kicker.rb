# encoding: utf-8

##  add to SportDb / Converter module / namespace - why? why not?


class KickerZine

###
# builtin team samples
#
#  use namespace/module
#   lets you use:
#     include KickerZine::Teams

module Teams

ENG1_TEAMS_2019_20 = <<TXT
  FC Liverpool
  Norwich City
  West Ham United
  Manchester City
  Crystal Palace
  FC Everton
  Leicester City
  Wolverhampton Wanderers
  FC Watford
  Brighton & Hove Albion
  FC Burnley
  FC Southampton
  AFC Bournemouth
  Sheffield United
  Tottenham Hotspur
  Aston Villa
  Newcastle United
  FC Arsenal
  Manchester United
  FC Chelsea
TXT

DE1_TEAMS_2019_20 = <<TXT
  Bayern München
  Hertha BSC
  Werder Bremen
  Fortuna Düsseldorf
  SC Freiburg
  1. FSV Mainz 05
  Bayer 04 Leverkusen
  SC Paderborn 07
  Borussia Dortmund
  FC Augsburg
  VfL Wolfsburg
  1. FC Köln
  Bor. Mönchengladbach
  FC Schalke 04
  Eintracht Frankfurt
  TSG Hoffenheim
  1. FC Union Berlin
  RB Leipzig
TXT

DE2_TEAMS_2019_20 = <<TXT
  VfB Stuttgart
  Hannover 96
  Dynamo Dresden
  1. FC Nürnberg
  VfL Osnabrück
  1. FC Heidenheim
  Holstein Kiel
  SV Sandhausen
  Hamburger SV
  SV Darmstadt 98
  SpVgg Greuther Fürth
  Erzgebirge Aue
  SV Wehen Wiesbaden
  Karlsruher SC
  Jahn Regensburg
  VfL Bochum
  Arminia Bielefeld
  FC St. Pauli
TXT

DE3_TEAMS_2019_20 = <<TXT
  1860 München
  Preußen Münster
  MSV Duisburg
  SG Sonnenhof Großaspach
  Hansa Rostock
  FC Viktoria Köln
  SV Meppen
  FSV Zwickau
  1. FC Kaiserslautern
  SpVgg Unterhaching
  Würzburger Kickers
  Bayern München II
  1. FC Magdeburg
  Eintracht Braunschweig
  Chemnitzer FC
  Waldhof Mannheim
  KFC Uerdingen 05
  Hallescher FC
  Carl Zeiss Jena
  FC Ingolstadt 04
TXT


AT1_TEAMS_2019_20 = <<TXT
  Rapid Wien
  RB Salzburg
  WSG Tirol
  Austria Wien
  FC Admira Wacker
  Wolfsberger AC
  Sturm Graz
  SKN St. Pölten
  Linzer ASK
  SCR Altach
  SV Mattersburg
  TSV Hartberg
TXT

AT2_TEAMS_2019_20 = <<TXT
  SV Ried
  Austria Klagenfurt
  Vorwärts Steyr
  Wacker Innsbruck
  Young Violets Austria Wien
  SV Horn
  Blau-Weiß Linz
  Kapfenberger SV
  FC Dornbirn 1913
  Austria Lustenau
  Floridsdorfer AC
  Grazer AK
  FC Liefering
  SKU Amstetten
  SV Lafnitz
  FC Juniors OÖ
TXT

ES1_TEAMS_2019_20 = <<TXT
  Athletic Bilbao
  FC Barcelona
  Celta Vigo
  Real Madrid
  FC Valencia
  Real Sociedad San Sebastian
  FC Villarreal
  FC Granada
  CD Leganes
  CA Osasuna
  Deportivo Alaves
  UD Levante
  Espanyol Barcelona
  FC Sevilla
  Atletico Madrid
  FC Getafe
  RCD Mallorca
  SD Eibar
  Real Betis Sevilla
  Real Valladolid
TXT

ES2_TEAMS_2019_20 = <<TXT
  Real Saragossa
  CD Teneriffa
  Racing Santander
  FC Malaga
  Deportivo La Coruna
  Real Oviedo
  Rayo Vallecano
  CD Mirandes
  UD Las Palmas
  SD Huesca
  CD Numancia
  AD Alcorcon
  FC Elche
  CF Fuenlabrada
  UD Almeria
  Albacete Balompie
  FC Cadiz
  SD Ponferradina
  FC Girona
  Sporting Gijon
  CD Lugo
  Extremadura UD
TXT

end # module Teams


#######################
# regex patterns

SPIELTAG_REGEX = /
                    (?<=\s|^)     # use zero assertion lookbehind
                    (?<round>\d{1,2})\. \s Spieltag
                    (?=\s|$)      # use zero assertion lookahead
                 /xi


DATE_REGEX = /
                (?<=\s|^)     # use zero assertion lookbehind
                   (?<day>\d{2})
                     \.
                   (?<month>\d{2})
                     \.
              (?=\s|$)      # use zero assertion lookahead
             /xi



def self.read( path, teams:, debug: false )
  txt = File.open( path, 'r:utf-8' ).read

  if debug
    ## e.g. convert
    ##    txt/at1_2018-19.txt     => to
    ##    txt/o/at1_2018-19.debug.txt
    debugpath = "#{File.dirname(path)}/o/#{File.basename(path,'.*')}.debug.txt"
  else
    debugpath = nil
  end

  parse( txt, teams: teams, debug: debug, debugpath: debugpath )
end



def self.parse( txt, teams:, debug: false, debugpath: nil )

  ## split teams into an array
  ## todo/fix: move to a helper for (re)use
  team_names = []
  teams.each_line do |line|
    line = line.strip
    next if line.empty?             ## skip
    next if line.start_with?( '#')  ## skip comments too

    team_names << line
  end
  puts "#{team_names.size} teams:"
  pp team_names


team_pattern = team_names.map do |team|
  ## escape space to \s
  ## escape dot (.) to \. (literal)
  ## escape () to \( and \)
  team_esc = team.gsub(' ', '\s').
                  gsub('.', '\.').
                  gsub('(', '\(').
                  gsub(')', '\)')

  "(?:#{team_esc})"
end.join('|')

pp team_pattern



team_regex = /
                (?<=\s|^)     # use zero assertion lookbehind
                (?<team>#{team_pattern})
                (?=\s|$)      # use zero assertion lookahead
             /xi


new_lines = []


i=0
last_round = nil
last_date  = nil
matches = []
teams = []


txt.each_line do |line|

  i+=1

  line = line.strip

  puts "#{i}: >#{line}<"

  ## check spieltag
  if (m=line.match(SPIELTAG_REGEX))
    puts "** bingo - round >#{m[:round]}<"
    last_round = m[:round].to_i

    line = line.sub( m[0], '«SPIELTAG»')
  elsif (m=line.match(DATE_REGEX))
    month = m[:month].to_i
    day   = m[:day].to_i
    year = month < 7 ? 2020 : 2019   ## fix: do not hardcode 2019/20 season!!!
    last_date = "#{year}-#{'%02d'% month}-#{'%02d'% day}"
    puts "** bingo - date #{last_date}"

    line = line.sub( m[0], '«DATE»')
  elsif (m=line.match(team_regex))
    teams << m[:team]

    if teams.size == 1
      if last_date
        puts "*** !!! ERROR !!!: no date expected before team1"
        exit 1
      end

      line = line.sub( m[0], '«TEAM1»')
      puts "** bingo - team1 >#{m[:team]}<"
    else
      if last_date.nil?
        puts "*** !!! ERROR !!!: date expected between team1 and team2"
        exit 1
      end

      line = line.sub( m[0], '«TEAM2»')
      puts "** bingo - team2 >#{m[:team]}<"

      match = SportDb::Struct::Match.new(
                 team1: teams[0],
                 team2: teams[1],
                 round: last_round,
                 date:  last_date )

      puts "** bingo - add new match: #{match.inspect}"
      matches << match

      ## reset
      teams     = []
      last_date = nil
    end
  else
    # skip - do nothing
  end


  puts "    >#{line}<"
  new_lines << line
end


if debug
  File.open( debugpath, 'w:utf-8' ) do |out|
    out << new_lines.join( "\n" )
  end
end


  pp matches
  matches
end  # method self.read



def self.convert_to_csv( path, outpath, teams:, debug: false )

  matches = read( path, teams: teams, debug: debug )

  CsvMatchWriter.write( outpath, matches )
end # method self.convert_to_csv

def self.convert_to_txt( path, outpath, teams:, title:, round:, lang: 'en', debug: false)

  matches = read( path, teams: teams, debug: debug )

  TxtMatchWriter.write( outpath, matches, title: title, round: round, lang: lang )
end # method self.convert_to_txt


end # class KickerZine
