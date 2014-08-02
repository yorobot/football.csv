# encoding: utf-8

## map football_data leagues to our own keys

FOOTBALL_DATA_LEAGUES = {
  'E0'  => 'eng1',  # english premier league
  'E1'  => 'eng2',  # english championship league
  'E2'  => 'eng3',  # english league 1
  'E3'  => 'eng4',  # english league 2
  'EC'  => 'eng5',  # english conference

  'SP1' => 'es1',   # spanish liga 1
  'SP2' => 'es2',   # spanish liga 2

  'F1'  => 'fr1',   # french ligue 1
  'F2'  => 'fr2',   # french ligue 2

  'I1'  => 'it1',   # italian serie a
  'I2'  => 'it2',   # italian serie b

  'D1'  => 'de1',   # german bundesliga
  'D2'  => 'de2',   # german 2. bundesliga

  'SC0' => 'sco1',  # scotish Premiership  # starting w/ 2013-14 season
  'SC1' => 'sco2',  # scotish Championship
  'SC2' => 'sco3',  # scotish League One
  'SC3' => 'sco4',  # scotish League Two

  'N1'  => 'nl1',   # dutch eredivisie

  'B1'  => 'be1',   # belgian pro league

  'P1'  => 'pt1',   # portugese Primeira Liga

  'T1'  => 'tr1',   # turkish Süper Lig

  'G1'  => 'gr1',   # greek Superleague
}


LEAGUES = {
  'eng1' => '1-premierleague',  # english premier league
  'eng2' => '2-championship',  # english championship league
  'eng3' => '3-league1',  # english league 1
  'eng4' => '4-league2',  # english league 2
  'eng5' => '5-conference',  # english conference

  'es1'  => '1-liga',  # spanish liga 1
  'es2'  => '2-liga2',  # spanish liga 2

  'fr1'  => '1-ligue1',  # french ligue 1
  'fr2'  => '2-ligue2',  # french ligue 2

  'it1'  => '1-seriea',  # italian serie a
  'it2'  => '2-serieb',  # italian serie b

  'de1'  => '1-bundesliga', # german bundesliga
  'de2'  => '2-bundesliga2', # german 2. bundesliga

  'sco1' => '1-premiership',   # scotish Premiership  # starting w/ 2013-14 season
  'sco2' => '2-championship',  # scotish Championship
  'sco3' => '3-league1',       # scotish League One
  'sco4' => '4-league2',       # scotish League Two

  'nl1'  => '1-eredivisie',  # dutch eredivisie

  'be1'  => '1-proleague',     # belgian pro league

  'pt1'  => '1-liga',          # portugese Primeira Liga

  'tr1'  => '1-superlig',      # turkish Süper Lig

  'gr1'  => '1-superleague',   # greek Superleague
}


##########################################
# hacks for renames/rebrandings/reorgs


ENG_LEAGUES_2003 = {  ## until (including) 2003-04 season
  'eng1' => '1-premierleague', # english premier league
  'eng2' => '2-division1',  # english division 1
  'eng3' => '3-division2',  # english division 2
  'eng4' => '4-division3',  # english division 3
}

# note: in season 1992/93 the premier league starts
ENG_LEAGUES_1991 = { ## until (including) 1991-92} season
  'eng1' => '1-division1', # english division 1
  'eng2' => '2-division2', # english division 2
}



SCO_LEAGUES_2012 = {    ## until (including) 2012-13 season
  'sco1' => '1-premierleague', # scotish Premiership
  'sco2' => '2-division1',      # scotish 1st division
  'sco3' => '3-division2',      # scotish League One
  'sco4' => '4-division3',      # scotish League Two
}

SCO_LEAGUES_1997 = {  ## until (including) 1997-98  season
  'sco1' => '1-premierdivision',  # scotish Premier division
  'sco2' => '2-division1',         # scotish 1st division
  'sco3' => '3-division2',         # scotish 2nd divions
  'sco4' => '4-division3',         # scotish 3rd divsion
}

FR_LEAGUES_2001 = { ## until (including) 2001-02 season
  'fr1'  => '1-division1',  # french ligue 1
  'fr2'  => '2-division2',  # french ligue 2
}

GR_LEAGUES_2005 = {  ## until (including) 2005-06 season
  'gr1' => '1-alphaethniki',   # greek Alpha Ethniki
}
