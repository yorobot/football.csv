
EXTRA_LEAGUE_MAPPINGS = {
  'ENG 1'  => 'ENG 3',   ## note: ENG 1 is Premier League (level 1) NOT League One (level 3)
  'ENG 2'  => 'ENG 4',   ## note: ENG 2 is Championship (level 2) NOT League Two (level 4)
  'CL'     => 'UEFA CL',    ##  how to deal with cl for Chile AND Champions Leauge??
  'EL'     => 'UEFA EL',
  ## 'RL TIR' => 'AUT RL T',   ## or use AUT RLT or AUT RL TIR ???
  ## 'RL SBG' => 'AUT RL S',
  ## 'RL VBG' => 'AUT RL V',
  
  ## 'FA TRO' => 'ENG FA TRO',  ## England FA Trophy
}


## shared list of tipp3 programs
# note: 44b_sat-nov-2 starts on a saturday!
PROGRAMS_2019 = %w[
  21a_tue-may-21   21b_fri-may-24
  22a_tue-may-28   22b_fri-may-31
  23a_tue-june-4   23b_fri-june-7
  24a_tue-june-11  24b_fri-june-14
  25a_tue-june-18  25b_fri-june-21
  26a_tue-june-25  26b_fri-june-28
  27a_tue-july-2   27b_fri-july-5
  28a_tue-july-9   28b_fri-july-12
  29a_tue-july-16  29b_fri-july-19
  30a_tue-july-23  30b_fri-july-26
  31a_tue-july-30  31b_fri-aug-2
  32a_tue-aug-6    32b_fri-aug-9
  33a_tue-aug-13   33b_fri-aug-16
  34a_tue-aug-20   34b_fri-aug-23
  35a_tue-aug-27   35b_fri-aug-30
  36a_tue-sep-3    36b_fri-sep-6
  37a_tue-sep-10   37b_fri-sep-13
  38a_tue-sep-17   38b_fri-sep-20
  39a_tue-sep-24   39b_fri-sep-27
  40a_tue-oct-1    40b_fri-oct-4
  41a_tue-oct-8    41b_fri-oct-11
  42a_tue-oct-15   42b_fri-oct-18
  43a_tue-oct-22   43b_fri-oct-25
  44a_tue-oct-29   44b_sat-nov-2
  45a_tue-nov-5    45b_fri-nov-8
  46a_tue-nov-12   46b_fri-nov-15
  47a_tue-nov-19   47b_fri-nov-22
  48a_tue-nov-26   48b_fri-nov-29
  49a_tue-dec-3    49b_fri-dec-6
  50a_tue-dec-10   50b_fri-dec-13
  51a_tue-dec-17   51b_fri-dec-20
  52a_mon-dec-23   52b_fri-dec-27
].map { |name| "2019-#{name}" }

PROGRAMS_2020 = %w[
  01a_mon-dec-30   01b_fri-jan-3
  02a_tue-jan-7
].map { |name| "2020-#{name}" } 


PROGRAMS = PROGRAMS_2019 + PROGRAMS_2020


HOCKEY_LEAGUES = [
  'NHL',     # USA NHL
  'KHL',     # Kontinental Hockey League
  'EH AUT',  # Österreich Erste Bank-EHL
  'EH GER',  # Deutschland Deutsche Eishockey Liga
  'INTGERC', # Germany Cup
  'EH SWE',  # Schweden Elitserien
  'EH ALP',  # Alps Hockey League
  'EH SUI',  # Schweiz National League A
  'EH FIN',  # Finnland SM-Liiga
  'EH ENG',  # England, Elite League
  'EH CZE',  # Tschechische Republik Extraliga
  'EH CZE2', # Tschechische Republik 1. Liga
  'EH CL',   # Champions Hockey League
  'EH WM',   # Eishockey WM 2019
  'EH TOUR', # Euro Hockey Tour
  'EH FS',   # Freundschaftsspiele, Herren
  'EH NOR',  # Norwegen GET-Ligaen
  'EH SVK',  # Slowakei Extraliga
]

HANDBALL_LEAGUES = [
  'HB EM',   # Handball Europameisterschaft
  'HB EMQ',  # Europameisterschaft Qualifikation
  'HB FS',   # Freundschaftsspiele, Herren
  'HB AUT',  # Österreich HLA
  'HB GER',  # Deutsche Handball Bundesliga
  'HBAUTSC', # Handball Supercup Österreich
  'HBGERSC', # Deutschland Supercup
  'EHF EUC', # EHF EURO Cup
  'HB CL',   # Champions League, Herren
  'HBWMQD',  # Weltmeisterschaft, Qualifikation, Damen
]

BASKETBALL_LEAGUES = [
  'BB AUT',  # Österreich Basketball Superliga
  'BB AUTC', # Basketball Cup Österreich
  'BBAUTSC', # Österreich, Herren Supercup
  'BB GER',  # Deutschland BBL
  'BB ESP',  # Spanien Spagnola ACB
  'BB ITA',  # Italien A1
  'BB FRA',  # Frankreich Pro A
  'BB POR',  # Portugal, LPB
  'BB WM',   # FIBA Weltmeisterschaft 
  'BB EL',   # Euroleague
  'BB BEL',  # Belgien Scooore League
  'BB CL',   # Basketball Champions League
  'BB EU C', # Europe Cup
  'BB SER',  # Serbien A1 League
  'BB TUR',  #Türkei TBL
  'NBA',     # USA NBA
  'BB EC',   # Eurocup
  'BB EMDA', # Europameisterschaft Damen
]

WINTER_LEAGUES = [
  'HE-SL',   # Ski Alpin, Herren Slalom
  'HE-RTL',  # Ski Alpin, Herren Riesentorlauf
]

MORE_LEAGUES = [
  'NFL',      # USA NFL
  'AFB AFL',  # Austrian Football League
  'RUG WM',   # Rugby Union WM
  'VB EM H',  # Volleyball Europameisterschaft Herren
  'TEN ATP',  # Tennis ATP
  'TEN WTA',  # Tennis WTA
  'F1',       # Formel 1
]


## national teams and/or women leagues
EXCLUDE_LEAGUES = [    # note: skip (ignore) all leagues/cups/tournaments with national (selction) teams for now
  'WM Q',       # WM Qualifikation
  'U20 WM',     # U20 Weltmeisterschaft
  'EM Q',       # Europameisterschaft Qualifikation
  'U21 EMQ',    # U21 EM Qualifikation
  'U21 EM',     # U21 Europameisterschaft
  'U19 EM',     # U19 Europameisterschaft
  'U19 EMQ',    # U19 EM Qualifikation
  'INT FS',     # Internationale Freundschaftsspiele
  'FS U21',     # U21 Freundschaftsspiele
  'FS U20',     # U20 Freundschaftsspiele
  'AFR CUP',    # Afrika Cup
  'AFR CQ',     # Africa Cup, Qualifikation
  'GOLF-C',     # Golf Cup in Katar
  'COPA AM',    # Copa America
  'G-CUP',      # Gold Cup
  'CCC NL',     # CONCACAF Nations League
  'UEFA NL',    # UEFA Nations League
  'COPA CA',    # Copa Centroamericana

  ## national leagues (women)
  'INT FSD',    # Internationale Freundschaftsspiele, Damen
  'EMQDA',      # EM Qualifikation, Damen
  'U19 DAQ',    # U19 EM Frauen, Qualifikation
  'WM DAM',     # Damen WM 2019 in Frankreich

  ## todo/fix: move to clubs leagues (women) - why? why not?
  'CL DAM',     # UEFA Champions League Damen
  'AUT DA',     # Österreich Frauen Bundesliga
  'DA CUP',     # Österreich Damen Cup

  ## misc
  'FS',       # Freundschaftsspiele International (Klub)
  'INT CHC',  # International Champions Cup
  'PL ASIA',  # Premier League Asia Trophy
  'EMR CUP',  # Emirates Cup
]
