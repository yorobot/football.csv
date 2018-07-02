# encoding: utf-8


## unify team names; team (builtin/known/shared) name mappings


## todo: check if defined?
##    if defined use merge hash - why? why not?


## used by CsvMatchReader

## cleanup team names - use local ("native") name with umlaut etc.



##############################
### de-deutschland

TEAMS_DE = {
  'Bayern Munich'      => 'Bayern München',
  'Bayern Muenchen'    => 'Bayern München',
  'Munich 1860'        => 'TSV 1860 München',
  'TSV 1860 Muenchen'  => 'TSV 1860 München',
  'Nurnberg'           => '1. FC Nürnberg',  ### todo: check if save to always map to 1. FC Nürnberg
  '1. FC Nuernberg'    => '1. FC Nürnberg',

  'FC Koln'            => '1. FC Köln',
  'F Koln'             => '1. FC Köln',  ## todo/fix: check might be Fortuna Köln!! (in season 73/74 in bl)
  '1. FC Koeln'        => '1. FC Köln',

  'Greuther Furth'      => 'Greuther Fürth',
  'Fortuna Dusseldorf'  => 'Fortuna Düsseldorf',
  'Fortuna Duesseldorf' => 'Fortuna Düsseldorf',
## todo/check if included (see generated teams.csv)
##  'Dusseldorf'         => 'Düsseldorf',    ## same as fortuna duesseldorf??
  'Saarbrucken'        => 'Saarbrücken',   ## todo: check if save to use 1. FC Saarbruecken??
  '1. FC Saarbruecken' => '1. FC Saarbrücken',
  'Bor. Moenchengladbach' => 'Bor. Mönchengladbach',
  'Preussen Muenster'   => 'Preussen Münster',
  'Gutersloh'           => 'Gütersloh',
  'Lubeck'              => 'Lübeck',
  'Osnabruck'           => 'Osnabrück',
}


############################################
## tr-turkey

TEAMS_TR = {
  'Karabukspor'     => 'Karabükspor',
  'Kasimpasa'       => 'Kasımpaşa',
  'Fenerbahce'      => 'Fenerbahçe',
  'Genclerbirligi'  => 'Gençlerbirliği',
  'Elazigspor'      => 'Elazığspor',
  'Besiktas'        => 'Beşiktaş',
  'Eskisehirspor'   => 'Eskişehirspor',
}



#############################################
## fr-france

TEAMS_FR = {
  'Amiens'      => 'Amiens SC',
  'Angers'      => 'Angers SCO',
  'Bordeaux'    => 'Girondins de Bordeaux',
  'Caen'        => 'Stade Malherbe Caen',  ## SM Caean
  'Dijon'       => 'Dijon FCO',
  'Guingamp'    => 'EA Guingamp',
  'Lille'       => 'Lille OSC',
  'Lyon'        => 'Olympique Lyonnais',
  'Marseille'   => 'Olympique de Marseille',
  'Metz'        => 'FC Metz',
  'Monaco'      => 'AS Monaco',
  'Montpellier' => 'Montpellier HSC',  ## Montpellier Hérault SC
  'Nantes'      => 'FC Nantes',
  'Nice'        => 'OGC Nice',
  'Paris SG'    => 'Paris Saint-Germain',
  'Rennes'      => 'Stade Rennais FC',
  'St Etienne'  => 'AS Saint-Étienne',
  'Strasbourg'  => 'RC Strasbourg',
  'Toulouse'    => 'Toulouse FC',
  'Troyes'      => 'ES Troyes AC',
  'Reims'       => 'Stade de Reims',
  'Nimes'       => 'Nîmes Olympique',

   'Ajaccio'      => 'AC Ajaccio',
   'Ajaccio GFCO' => 'GFC Ajaccio',

   'Auxerre'         => 'AJ Auxerre',
   'Bourg Peronnas'  => 'Bourg-en-Bresse 01',   ## Bourg-en-Bresse
   'Brest'           => 'Stade Brestois 29',
   'Chateauroux'     => 'LB Châteauroux',
   'Clermont'        => 'Clermont Foot 63',
   'Le Havre'        => 'Le Havre AC',
   'Lens'            => 'RC Lens',
   'Lorient'         => 'FC Lorient',
   'Nancy'           => 'AS Nancy Lorraine',
   'Niort'           => 'Chamois Niortais FC',
   'Orleans'         => 'US Orléans',
   ## 'Paris FC'        => 'Paris FC',
   'Quevilly Rouen'  => 'US Quevilly-Rouen Métropole',  ## Quevilly-Rouen
   'Sochaux'         => 'FC Sochaux-Montbéliard',
   'Tours'           => 'Tours FC',
   'Valenciennes'    => 'Valenciennes FC',
}



##
# Red Star History
# - Red Star FC 93 (2003-2012)
# - Red Star FC (2012-)


### todo:
##  change to yaml datafiles - why? why not?
##
##  eg.:
##   Paris St Germain: [Paris SG, PSG, ...]




##
##  todo/fix: change to TEAM_MAPPINGS  - why? why not?


## merge all hashes into one (TEAMS hash)
##   e.g. TEAMS = {}.merge( TEAMS_DE ).merge( TEAMS_TR )
TEAMS = [TEAMS_DE, TEAMS_FR, TEAMS_TR].reduce( {} ) { |memo,h| memo.merge( h ) }

