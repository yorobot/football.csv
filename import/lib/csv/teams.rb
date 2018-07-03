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
   'Quevilly Rouen'  => 'US Quevilly-Rouen Métropole',  ## Quevilly-Rouen
   'Sochaux'         => 'FC Sochaux-Montbéliard',
   'Tours'           => 'Tours FC',
   'Valenciennes'    => 'Valenciennes FC',

    ## as is 1:1 (register/add for pretty print names check/lookup)
    'Paris FC'        => 'Paris FC',
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


############################
## es-espana (spain) - [es]


TEAMS_ES = {
  'Malaga'      => 'Málaga CF',
  'Malaga B'    => 'Málaga CF B',

  'Sevilla'       => 'Sevilla FC',
  'Sevilla B'     => 'Sevilla FC B',

  'Ath Madrid'    => 'Atlético Madrid',   ## Atlético de Madrid
  'Ath Madrid B'  => 'Atlético Madrid B', 

  'Las Palmas'  => 'UD Las Palmas',
  'Espanol'     => 'RCD Español',
  'Getafe'      => 'Getafe CF',
  'La Coruna'   => 'RCD La Coruña',
  'Sociedad'    => 'Real Sociedad',
  'Vallecano'   => 'Rayo Vallecano',
  'Valencia'    => 'Valencia CF',
  'Ath Bilbao'   => 'Athletic Club Bilbao',  ## Athletic Club
  'Ath Bilbao B' => 'Athletic Club Bilbao B',
  'Barcelona'    => 'FC Barcelona',
  'Barcelona B'  => 'FC Barcelona B',
  'Betis'       => 'Real Betis',
  'Levante'     => 'Levante UD',
  'Celta'       => 'RC Celta Vigo',   ## R. C. Celta de Vigo
  'Sp Gijon'    => 'Sporting Gijón',   ## Sporting de Gijón
  'Real Madrid'   => 'Real Madrid CF',
  'Real Madrid B' => 'Real Madrid CF B',

  
  'Alaves'    => 'Deportivo Alavés',
  'Albacete'  => 'Albacete Balompié',
  'Alcorcon'  => 'A. D. Alcorcón',
  'Alcoyano'  => 'CD Alcoyano',
  'Algeciras' => 'Algeciras CF',
  'Alicante'  => 'Alicante CF',
  'Almeria'   => 'UD Almería',

  'Badajoz'   => 'CD Badajoz',
  'Burgos'    => 'Burgos CF',

  'Cadiz'     => 'Cádiz CF',
  'Cartagena' => 'FC Cartagena',
  'Castellon'  => 'CD Castellón',
  'Ciudad de Murcia' => 'Real Murcia CF',
  'Compostela'  => 'SD Compostela',
  'Cordoba'     => 'Córdoba CF',

   'Ecija'       => 'Écija Balompié',
   'Elche'        => 'Elche CF',
   'Extremadura'  => 'CF Extremadura',
   'Ferrol'       => 'Racing Ferrol',

   'Gimnastic'  => 'Gimnàstic Tarragona',
   'Girona'     => 'Girona FC',

   'Guadalajara'  => 'CD Guadalajara',
   'Hercules'     => 'Hércules CF',
   'Huesca'       => 'SD Huesca',
  
  
  'Granada'     => 'Granada CF',   ## note: different from Granada 74 !!!
  'Granada 74'  => 'Granada 74',  ## see https://es.wikipedia.org/wiki/Granada_74_Club_de_F%C3%BAtbol

  'Eibar'       => 'SD Eibar',
  'Villarreal'  => 'Villarreal CF',  
  'Villareal'     => 'Villarreal CF',    ## fix typo!!
  'Villarreal B'  => 'Villarreal CF B',

'Jaen'       => 'Real Jaén CF',
'Leganes'    => 'CD Leganés',
'Leonesa'    => 'Cultural Leonesa',
'Lerida'     => 'UE Lleida',
'Lleida'     => 'UE Lleida',
'Llagostera' => 'UE Llagostera',
'Logrones'   => 'CD Logroñés',
'Lorca'      => 'Lorca FC',
'Lugo'       => 'CD Lugo',
'Mallorca'   => 'RCD Mallorca',
'Mallorca B'  => 'RCD Mallorca B',
'Merida'     => 'CP Mérida',
'Mirandes'   => 'CD Mirandés',
'Murcia'     => 'Real Murcia CF',

'Numancia'      => 'CD Numancia',
'Osasuna'       => 'CA Osasuna',
'Ourense'       => 'CD Ourense',
'Orense'        => 'CD Ourense',  ## fix typo!!
'Oviedo'        => 'Real Oviedo',
'Poli Ejido'    => 'Polideportivo Ejido',
'Ponferradina'  => 'SD Ponferradina',
'Pontevedra'    => 'Pontevedra CF',

'Real Union'     => 'Real Unión',
'Recreativo'     => 'Recreativo Huelva',
'Reus Deportiu'  => 'CF Reus',
'Sabadell'       => 'CE Sabadell',
'Salamanca'      => 'UD Salamanca',
'Santander'      => 'Real Racing Santander',

'Tenerife'       => 'CD Tenerife',
'Terrassa'       => 'Terrassa FC',
'Toledo'         => 'CD Toledo',
'U.Las Palmas'   => 'Universidad Las Palmas',
'UCAM Murcia'    => 'UCAM Murcia',

'Valladolid'     => 'Real Valladolid CF',
'Vecindario'     => 'UD Vecindario',

'Xerez'          => 'Xerez CD',
'Zaragoza'       => 'Real Zaragoza',  
}


##########################################
# nl-netherlands

TEAMS_NL={

'AZ Alkmaar'      => 'AZ Alkmaar',
'Ajax'            => 'Ajax Amsterdam',
'Cambuur'         => 'SC Cambuur',
'Den Bosch'       => 'FC Den Bosch',
'Den Haag'        => 'ADO Den Haag',
'Dordrecht'       => 'FC Dordrecht',
'Excelsior'       => 'SBV Excelsior',    ## SBV Excelsior Rotterdam
'Feyenoord'       => 'Feyenoord Rotterdam',
'For Sittard'     => 'Fortuna Sittard',
'Go Ahead Eagles' => 'Go Ahead Eagles',
'Graafschap'      => 'BV De Graafschap',
'Groningen'       => 'FC Groningen',
'Heerenveen'      => 'SC Heerenveen',
'Heracles'        => 'Heracles Almelo',
'MVV Maastricht'  => 'MVV Maastricht',
'NAC Breda'       => 'NAC Breda',
'Nijmegen'        => 'NEC	Nijmegen',
'PSV Eindhoven'   => 'PSV Eindhoven',

'Roda'             => 'Roda JC Kerkrade',
'Roda JC'          => 'Roda JC Kerkrade',

'Roosendaal'       => 'RBC Roosendaal',

'Sparta'           => 'Sparta Rotterdam',
'Sparta Rotterdam' => 'Sparta Rotterdam',

'Twente'           => 'FC Twente',
'Utrecht'          => 'FC Utrecht',
'VVV Venlo'        => 'VVV Venlo',
'Vitesse'          => 'Vitesse Arnhem',
'Volendam'         => 'FC Volendam',
'Waalwijk'         => 'RKC Waalwijk',
'Willem II'        => 'Willem II',    ## Willem II Tilburg
'Zwolle'           => 'PEC Zwolle',
}



##########################################
# be-belgium   - [nl,fr,de]


TEAMS_BE = {
  'Anderlecht'   => 'RSC Anderlecht',
  'Antwerp'      => 'Royal Antwerp FC',
  'Charleroi'    => 'Sporting Charleroi',   ##  [fr]	Royal Charleroi Sporting Club; Sporting de Charleroi
  'Eupen'        => 'KAS Eupen',    ## [de]
  'Genk'         => 'KRC Genk',
  'Gent'         => 'KAA Gent',
  'Kortrijk'     => 'KV Kortrijk',
  'Lokeren'      => 'KSC Lokeren OV',  ##  Sporting Lokeren
  'Mechelen'     => 'KV Mechelen',
  'Mouscron'     => 'Royal Excel Moeskroen',
  'Oostende'     => 'KV Oostende',
  'St Truiden'   => 'Sint-Truidense VV',
  'Standard'     => 'Standard Liège',  ## [fr] Standard de Liège
  'Waasland-Beveren'  => 'KVRS Waasland - SK Beveren',
  'Waregem'      => 'SV Zulte Waregem',
   'Westerlo'    => 'KVC Westerlo',
   'Lierse'  => 'K. Lierse SK',

   ## as is 1:1  (register/add for pretty print names check/lookup)
   'Club Brugge'         => 'Club Brugge',  ## Club Brugge KV
   'Oud-Heverlee Leuven' => 'Oud-Heverlee Leuven',
   'Cercle Brugge'       => 'Cercle Brugge',   ## Cercle Brugge KSV
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



##
##  todo/fix: change to TEAM_MAPPINGS  - why? why not?


## merge all hashes into one (TEAMS hash)
##   e.g. TEAMS = {}.merge( TEAMS_DE ).merge( TEAMS_TR )
TEAMS = [TEAMS_DE, TEAMS_FR, TEAMS_ES, TEAMS_BE, TEAMS_TR].reduce( {} ) { |memo,h| memo.merge( h ) }



###
## reverse hash for lookup/list of "official / registered(?)"
##    pretty  recommended unique (long form)
##    team names

# like invert but not lossy
# {"one"=>1,"two"=>2, "1"=>1, "2"=>2}.inverse => {1=>["one", "1"], 2=>["two", "2"]}
PRINT_TEAMS = TEAMS.each_with_object({}) do |(key,value),out|
  out[value] ||= []
  out[value] << key
end
