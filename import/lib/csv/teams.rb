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
  'Greuther Furth'     => 'Greuther Fürth',
  'Fortuna Dusseldorf' => 'Fortuna Düsseldorf',
  'Fortuna Duesseldorf'=> 'Fortuna Düsseldorf',
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
### tr-turkey
TEAMS_TR = {
  'Karabukspor'     => 'Karabükspor',
  'Kasimpasa'       => 'Kasımpaşa',
  'Fenerbahce'      => 'Fenerbahçe',
  'Genclerbirligi'  => 'Gençlerbirliği',
  'Elazigspor'      => 'Elazığspor',
  'Besiktas'        => 'Beşiktaş',
  'Eskisehirspor'   => 'Eskişehirspor',
}



##
##  todo/fix: change to TEAM_MAPPINGS  - why? why not?


## merge all hashes into one (TEAMS hash)
##   e.g. TEAMS = {}.merge( TEAMS_DE ).merge( TEAMS_TR )
TEAMS = [TEAMS_DE, TEAMS_TR].reduce( {} ) { |memo,h| memo.merge( h ) }
