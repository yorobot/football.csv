

def get_league( repo, year, basename)
  if repo == 'en-england' || repo == 'eng-england'
    if year <= 1991
      league = ENG_LEAGUES_1991[basename]
    elsif year <= 2003
      league = ENG_LEAGUES_2003[basename]     ## hack: for england for now (make more generic???)
    else
      league = LEAGUES[basename]
    end
  elsif repo == 'sco-scotland'
    if year <= 1997
      league = SCO_LEAGUES_1997[basename]
    elsif year <= 2012
      league = SCO_LEAGUES_2012[basename]
    else
      league = LEAGUES[basename]
    end
  elsif year <= 2001 && repo == 'fr-france'
    league = FR_LEAGUES_2001[basename]
  elsif year <= 2005 && repo == 'gr-greece'
    league = GR_LEAGUES_2005[basename]
  else
    league = LEAGUES[basename]
  end
  league
end



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

