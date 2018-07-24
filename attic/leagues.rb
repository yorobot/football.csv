

def get_old_league( repo, year, basename )
  if year <= 2003 && repo == 'en-england'
    league = OLD_EN_LEAGUES_2003[basename]     ## hack: for england for now (make more generic???)
  elsif year <= 2001 && repo == 'fr-france'
    league = OLD_FR_LEAGUES_2001[basename]
  elsif year <= 1997 && repo == 'sco-scotland'
    league = OLD_SCO_LEAGUES_1997[basename]
  elsif year <= 2012 && repo == 'sco-scotland'
    league = OLD_SCO_LEAGUES_2012[basename]
  elsif year <= 2005 && repo == 'gr-greece'
    league = OLD_GR_LEAGUES_2005[basename]
  else
    league = OLD_LEAGUES[basename]
  end
  league
end



LEAGUES = {

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
