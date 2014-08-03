# encoding: utf-8


## cleanup team names - use local ("native") name with umlaut etc.
TEAMS = {
  ### de-deutschland
  'Bayern Munich'      => 'Bayern München',
  'Bayern Muenchen'    => 'Bayern München',
  'Munich 1860'        => 'TSV 1860 München',
  'TSV 1860 Muenchen'  => 'TSV 1860 München',
  'Nurnberg'           => '1. FC Nürnberg',  ### todo: check if save to always map to 1. FC Nürnberg
  '1. FC Nuernberg'    => '1. FC Nürnberg',
  'FC Koln'            => '1. FC Köln',
  'F Koln'             => '1. FC Köln',
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

  ### tr-turkey
  'Karabukspor'     => 'Karabükspor',
  'Kasimpasa'       => 'Kasımpaşa',
  'Fenerbahce'      => 'Fenerbahçe',
  'Genclerbirligi'  => 'Gençlerbirliği',
  'Elazigspor'      => 'Elazığspor',
  'Besiktas'        => 'Beşiktaş',
  'Eskisehirspor'   => 'Eskişehirspor',
}

