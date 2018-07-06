# encoding: utf-8


## unify team names; team (builtin/known/shared) name mappings


## todo: check if defined?
##    if defined use merge hash - why? why not?


## used by CsvMatchReader

## cleanup team names - use local ("native") name with umlaut etc.



##############################
### de-deutschland

TEAMS_DE = <<TXT
  Bayern Munich, Bayern Muenchen         =>  Bayern München,   München
  Munich 1860, TSV 1860 Muenchen         =>  TSV 1860 München, München

### todo: check if save to always map Nurnberg to 1. FC Nürnberg
  Nurnberg, 1. FC Nuernberg              =>  1. FC Nürnberg, Nürnberg

## todo/fix: check F Koln might be Fortuna Köln!! (in season 73/74 in bl)
  F Koln, FC Koln, 1. FC Koeln           => 1. FC Köln, Köln

  Greuther Furth                            => Greuther Fürth, Fürth
  Fortuna Dusseldorf, Fortuna Duesseldorf   => Fortuna Düsseldorf, Düsseldorf

## todo/check if included (see generated teams.csv)
##  Dusseldorf         => Düsseldorf     ## same as fortuna duesseldorf??

##  Saarbrucken        => Saarbrücken    ## todo: check if save to use 1. FC Saarbruecken??
  1. FC Saarbruecken                        => 1. FC Saarbrücken, Saarbrücken
  Bor. Moenchengladbach                     => Bor. Mönchengladbach, Mönchengladbach
  Preussen Muenster                         => Preussen Münster, Münster
  Gutersloh                                 => Gütersloh, Gütersloh
  Lubeck                                    => Lübeck, Lübeck
  Osnabruck                                 => Osnabrück, Osnabrück
TXT


#############################################
## fr-france (and mc-monaco)

TEAMS_MC = <<TXT
   Monaco      => AS Monaco, Monaco
TXT


TEAMS_FR = <<TXT
  Amiens      => Amiens SC, ?
  Angers      => Angers SCO, ?
  Bordeaux    => Girondins de Bordeaux, Bordeaux

  Caen        => Stade Malherbe Caen, ?    ## use - SM Caean - why? why not?
  Dijon       => Dijon FCO, Dijon
  Guingamp    => EA Guingamp, ?
  Lille       => Lille OSC, Lille
  Lyon        => Olympique Lyonnais, Lyon
  Marseille   => Olympique de Marseille, Marseille
  Metz        => FC Metz, Metz

  Montpellier => Montpellier HSC, Montpellier   ## use - Montpellier Hérault SC - why? why not?
  Nantes      => FC Nantes, Nantes
  Nice        => OGC Nice, Nice

  Paris SG    => Paris Saint-Germain, Paris
  Paris FC    => Paris FC, Paris

  Rennes      => Stade Rennais FC, Rennes
  St Etienne  => AS Saint-Étienne, ?
  Strasbourg  => RC Strasbourg, Strasbourg
  Toulouse    => Toulouse FC, Toulouse
  Troyes      => ES Troyes AC, ?
  Reims       => Stade de Reims, Reims
  Nimes       => Nîmes Olympique, Nîmes

   Ajaccio         => AC Ajaccio,  Ajaccio
   Ajaccio GFCO    => GFC Ajaccio, Ajaccio

   Auxerre         => AJ Auxerre, ?
   Bourg Peronnas  => Bourg-en-Bresse 01, ?    ## use - Bourg-en-Bresse - why? why not?
   Brest           => Stade Brestois 29, Brest
   Chateauroux     => LB Châteauroux, ?
   Clermont        => Clermont Foot 63, Clermont
   Le Havre        => Le Havre AC, Le Havre
   Lens            => RC Lens, ?
   Lorient         => FC Lorient, ?
   Nancy           => AS Nancy Lorraine, Nancy
   Niort           => Chamois Niortais FC, ?
   Orleans         => US Orléans, Orléans

   Quevilly Rouen  => US Quevilly-Rouen Métropole,  ?   ## use Quevilly-Rouen - why? why not?
   Sochaux         => FC Sochaux-Montbéliard, ?
   Tours           => Tours FC, Tours
   Valenciennes    => Valenciennes FC, ?

  Arles            => AC Arles-Avignon, ?
  Bastia           => SC Bastia, Bastia
  CA Bastia        => CA Bastia, Bastia

  Beauvais         => AS Beauvais Oise, ?

  Besancon         => Racing Besançon, ?   ## use Besançon RC - why? why not?
  Boulogne         => US Boulogne, ?
  Cannes           => AS Cannes, Cannes
  Charleville      => FCO Charleville,
  Creteil          => US Créteil,
  Epinal           => SAS Épinal,
  Evian Thonon Gaillard  => Évian TG FC,    ## use Évian Thonon-Gaillard FC - why? why not?
  Grenoble         => Grenoble Foot 38, Grenoble
  Gueugnon       => FC Gueugnon, ?
  Istres         => FC Istres, ?
  Laval          => Stade Lavallois, ?
  Le Mans        => Le Mans FC, Le Mans
  Libourne       => FC Libourne-Saint-Seurin,
  Louhans-Cuis.  => CS Louhans-Cuiseaux,
  Martigues      => FC Martigues,
  Mulhouse       => FC Mulhouse, Mulhouse
  Perpignan      => Perpignan FC,

  ##
  # Red Star History
  # - Red Star FC 93 (2003-2012)
  # - Red Star FC (2012-)
  Red Star, Red Star 93  => Red Star FC,

  Rouen          => FC Rouen,
  Sedan          => CS Sedan-Ardennes,
  Sete           => FC Sète,
  St Brieuc      => Stade Briochin,
  Toulon         => Sporting Toulon Var,

  Valence        => ASOA Valence, Valence   ## use Olympique Valence - why? why not?
  Vannes         => Vannes OC,
  Wasquehal      => Wasquehal Foot,         ## use ES Wasquehal - why? why not?
TXT



############################
## es-espana (spain) - [es]


TEAMS_ES = <<TXT
  Malaga         => Málaga CF,   Málaga
  Malaga B       => Málaga CF B, Málaga

  Sevilla       => Sevilla FC,   Sevilla
  Sevilla B     => Sevilla FC B, Sevilla

  Ath Madrid    => Atlético Madrid,    Madrid    ## use Atlético de Madrid - why? why not?
  Ath Madrid B  => Atlético Madrid B,  Madrid

  Real Madrid   => Real Madrid CF,   Madrid
  Real Madrid B => Real Madrid CF B, Madrid

  Getafe        => Getafe CF, ?


  Barcelona    => FC Barcelona,   Barcelona
  Barcelona B  => FC Barcelona B, Barcelona

  Espanol      => RCD Español, Barcelona


  Las Palmas     => UD Las Palmas,          Las Palmas
  U.Las Palmas   => Universidad Las Palmas, Las Palmas

  La Coruna    => RCD La Coruña, La Coruña
  Sociedad     => Real Sociedad,
  Vallecano   => Rayo Vallecano,
  Valencia    => Valencia CF, Valencia


  Ath Bilbao   => Athletic Club Bilbao,   Bilbao    ## use Athletic Club - why? why not?
  Ath Bilbao B => Athletic Club Bilbao B, Bilbao
  Betis       => Real Betis,
  Levante     => Levante UD,
  Celta       => RC Celta Vigo,             ## use R. C. Celta de Vigo - why? why not?
  Sp Gijon    => Sporting Gijón, Gijón      ## use Sporting de Gijón - why? why not?


  Alaves    => Deportivo Alavés,
  Albacete  => Albacete Balompié,
  Alcorcon  => AD Alcorcón,
  Alcoyano  => CD Alcoyano,
  Algeciras => Algeciras CF,
  Alicante  => Alicante CF,
  Almeria   => UD Almería,

  Badajoz   => CD Badajoz,
  Burgos    => Burgos CF,

  Cadiz     => Cádiz CF,
  Cartagena => FC Cartagena,
  Castellon  => CD Castellón,
  Ciudad de Murcia => Real Murcia CF,
  Compostela  => SD Compostela,
  Cordoba     => Córdoba CF,

   Ecija       => Écija Balompié,
   Elche        => Elche CF,
   Extremadura  => CF Extremadura,
   Ferrol       => Racing Ferrol,

   Gimnastic  => Gimnàstic Tarragona,
   Girona     => Girona FC,

   Guadalajara  => CD Guadalajara,
   Hercules     => Hércules CF,
   Huesca       => SD Huesca,


   ## note: different from Granada 74 <=> Granda (CF) !!!
   ##   see https://es.wikipedia.org/wiki/Granada_74_Club_de_Fútbol
   Granada        => Granada CF, Granada
   Granada 74     => Granada 74, Granada

  Eibar       => SD Eibar,

  Villarreal, Villareal   => Villarreal CF,    Villarreal    ## fix typo Villareal
  Villarreal B            => Villarreal CF B,  Villarreal

  Jaen            => Real Jaén CF,
  Leganes         => CD Leganés,
  Leonesa         => Cultural Leonesa,
  Lerida, Lleida  => UE Lleida,
  Llagostera      => UE Llagostera,
  Logrones        => CD Logroñés,
  Lorca           => Lorca FC,
  Lugo            => CD Lugo,

  Mallorca        => RCD Mallorca,   Mallorca
  Mallorca B      => RCD Mallorca B, Mallorca

  Merida     => CP Mérida,
  Mirandes   => CD Mirandés,

  Murcia         => Real Murcia CF, Murcia
  UCAM Murcia    => UCAM Murcia,    Murcia

  Numancia         => CD Numancia,
  Osasuna          => CA Osasuna,
  Ourense, Orense  => CD Ourense,
  Oviedo           => Real Oviedo,
  Poli Ejido    => Polideportivo Ejido,
  Ponferradina  => SD Ponferradina,
  Pontevedra    => Pontevedra CF,

  Real Union     => Real Unión,
  Recreativo     => Recreativo Huelva,
  Reus Deportiu  => CF Reus,
  Sabadell       => CE Sabadell,
  Salamanca      => UD Salamanca,
  Santander      => Real Racing Santander,

  Tenerife       => CD Tenerife,
  Terrassa       => Terrassa FC,
  Toledo         => CD Toledo,

  Valladolid     => Real Valladolid CF,
  Vecindario     => UD Vecindario,

  Xerez          => Xerez CD,
  Zaragoza       => Real Zaragoza,
TXT


##########################################
# it-italy  [it]

TEAMS_IT= <<TXT
  Roma         =>  AS Roma,  Roma
  Lazio        =>  SS Lazio, Roma

  Inter        =>  FC Internazionale Milano, Milano
  Milan        =>  AC Milan,                 Milano

  Juventus     =>  Juventus,    Torino
  Torino       =>  Torino FC,   Torino

  Verona       => Hellas Verona FC, Verona
  Chievo       => AC Chievo Verona, Verona

  Genoa        =>  Genoa CFC,      Genova
  Sampdoria    =>  UC Sampdoria,   Genova

  Atalanta     => Atalanta BC,     Bergamo
  Benevento    => Benevento,       Benevento
  Bologna      => Bologna FC,      Bologna
  Cagliari     => Cagliari Calcio, Cagliari
  Crotone      => FC Crotone,      Crotone
  Fiorentina   =>  ACF Fiorentina, Firenze
  Napoli       =>  SSC Napoli,     Napoli
  Sassuolo     =>  US Sassuolo Calcio, Sassuolo
  Spal         =>  SPAL,           Ferrara
  Udinese      =>  Udinese Calcio, Udine


  Ascoli       =>  Ascoli, Ascoli Piceno
  Avellino     =>  Avellino, Avellino
  Bari         =>  Bari, Bari
  Brescia      =>  Brescia, Brescia
  Carpi        =>  Carpi, Carpi
  Cesena        => Cesena, Cesena
   Cittadella   => Cittadella, Cittadella
  Cremonese     => Cremonese, Cremona
  Empoli        => Empoli, Empoli
  Foggia        => Foggia, Foggia
  Frosinone     => Frosinone, Frosinone
  Novara        => Novara, Novara
  Palermo       => Palermo, Palermo
  Parma         => Parma, Parma
  Perugia       => Perugia, Perugia
  Pescara       => Pescara, Pescara
  Pro Vercelli  =>  Pro Vercelli, Vercelli
  Salernitana   => Salernitana, Salerno
  Spezia        => Spezia, La Spezia
  Ternana       => Ternana, Terni
  Venezia       => Venezia, Venezia
  Virtus Entella   =>   Virtus Entella, Chiavari
TXT


##########################################
# nl-netherlands

TEAMS_NL= <<TXT

Ajax                      => Ajax Amsterdam, Amsterdam

Feyenoord                 => Feyenoord Rotterdam,     Rotterdam
Sparta, Sparta Rotterdam  => Sparta Rotterdam,        Rotterdam
Excelsior                 => SBV Excelsior Rotterdam, Rotterdam    ## use SBV Excelsior - why? why not?


AZ Alkmaar      => AZ Alkmaar,
Cambuur         => SC Cambuur,
Den Bosch       => FC Den Bosch,
Den Haag        => ADO Den Haag,
Dordrecht       => FC Dordrecht,
For Sittard     => Fortuna Sittard,
Go Ahead Eagles => Go Ahead Eagles, ?
Graafschap      => BV De Graafschap,
Groningen       => FC Groningen,
Heerenveen      => SC Heerenveen,
Heracles        => Heracles Almelo,
MVV Maastricht  => MVV Maastricht, Maastricht
NAC Breda       => NAC Breda,
Nijmegen        => NEC Nijmegen,
PSV Eindhoven   => PSV Eindhoven, Eindhoven

Roda, Roda JC   => Roda JC Kerkrade

Roosendaal       => RBC Roosendaal,


Twente           => FC Twente,
Utrecht          => FC Utrecht,
VVV Venlo        => VVV Venlo,
Vitesse          => Vitesse Arnhem,
Volendam         => FC Volendam,
Waalwijk         => RKC Waalwijk,


Willem II        => Willem II Tilburg, Tilburg    ## use Willem II - why? why not?
Zwolle           => PEC Zwolle,
TXT



##########################################
# be-belgium   - [nl,fr,de]


TEAMS_BE = <<TXT
  Anderlecht     => RSC Anderlecht, Brussels
  FC Brussels    => FC Brussels,    Brussels


  Antwerp      => Royal Antwerp FC,
  Charleroi    => Sporting Charleroi,   ##  [fr]	Royal Charleroi Sporting Club; Sporting de Charleroi
  Eupen        => KAS Eupen,    ## [de]
  Genk         => KRC Genk,
  Gent         => KAA Gent,
  Kortrijk     => KV Kortrijk,
  Lokeren      => KSC Lokeren OV,  ##  Sporting Lokeren
  Mechelen     => KV Mechelen,

  Mouscron, Mouscron-Peruwelz    => Royal Excel Moeskroen,

  Oostende     => KV Oostende,
  St Truiden   => Sint-Truidense VV,
  Standard          => Standard Liège,  ## [fr] Standard de Liège
  Waasland-Beveren  => Waasland-Beveren,  ## KVRS Waasland - SK Beveren
  Waregem      => SV Zulte Waregem,
   Westerlo    => KVC Westerlo,
   Lierse       => K Lierse SK,

  Aalst    => SC Eendracht Aalst,
  Bergen   => RAEC Mons,
  Beveren   => KSK Beveren,
  Dender    => FCV Dender EH,
  Geel          => KFC Verbroedering Geel,
  Germinal      => Germinal Beerschot,
  Harelbeke     => KRC Harelbeke,
  Heusden Zolder => K Heusden-Zolder,
  Lommel         => KFC Lommel SK,
  Louvieroise    => RAA Louviéroise,
  Molenbeek      => RWD Molenbeek,
  Roeselare   => KSV Roeselare,
  Seraing     => RFC Seraing,
  Tubize      => AFC Tubize,

   Club Brugge         => Club Brugge,    Brugge     ## Club Brugge KV
   Cercle Brugge       => Cercle Brugge,  Brugge     ## Cercle Brugge KSV

    Oud-Heverlee Leuven => Oud-Heverlee Leuven,
TXT


############################################
## tr-turkey
##
##  see https://en.wikipedia.org/wiki/Süper_Lig


TEAMS_TR = <<TXT
 Fenerbahce        =>  Fenerbahçe İstanbul SK,  İstanbul
 Galatasaray       =>  Galatasaray İstanbul AŞ, İstanbul
 Besiktas          =>  Beşiktaş İstanbul JK,    İstanbul
 Kasimpasa         =>  Kasımpaşa İstanbul SK,   İstanbul

 ## (double) check if Buyuksehyr matching !?
 Buyuksehyr        =>  İstanbul Başakşehir,  İstanbul

 Genclerbirligi    =>  Gençlerbirliği Ankara SK, Ankara
 Osmanlispor       =>  Osmanlıspor Ankara,       Ankara

 Karabukspor      =>  Kardemir Karabükspor,  Karabük
 Elazigspor       =>  Elazığspor,            Elazığ
 Eskisehirspor    =>  Eskişehirspor,         Eskişehir

 Akhisar Belediyespor =>  Akhisar Belediyespor, Akhisar
 Alanyaspor       =>      Alanyaspor,  Alanya
 Antalyaspor      =>      Antalyaspor, Antalya
 Bursaspor        =>      Bursaspor,   Bursa
 Goztep           =>      Göztepe Izmir, İzmir
 Kayserispor      =>      Kayserispor,   Kayseri
 Konyaspor        =>      Konyaspor,     Konya
 Sivasspor        =>      Sivasspor,     Sivas
 Trabzonspor      =>      Trabzonspor AŞ, Trabzon
 Yeni Malatyaspor  =>     Yeni Malatyaspor, Malatya

 Adanaspor       =>       Adanaspor,       Adana
 Gaziantepspor   =>       Gaziantepspor,	 Gaziantep
 Rizespor        =>       Çaykur Rizespor, Rize

 Balikesirspor       =>   Balıkesirspor,       Balıkesir
 Erciyesspor         =>   Kayseri Erciyesspor, Kayseri
 Mersin Idman Yurdu  =>   Mersin İdmanyurdu,   Mersin
TXT



def teams_txt_to_h( txt )
  h = {}
  txt.each_line do |line|
    line = line.strip

    next if line.empty?
    next if line.start_with?( '#' )   ## skip comments too

    ## strip inline comments too
    ##  e.g Eupen        => KAS Eupen,    ## [de]
    ##   => Eupen        => KAS Eupen,
    line = line.sub( /#.*/, '' ).strip

    pp line
    names_line, team_line = line.split( '=>' )

    names = names_line.split( ',' )   # team names
    team  = team_line.split( ',' )   # (canoncial) team name, team_city

    ## remove leading and trailing spaces
    names = names.map { |name| name.strip }
    team  = team.map { |team| team.strip }
    pp names
    pp team


    canonical_team_name = team[0]
    team_city           = team[1]    ## note: team_city is optional for now (might be nil!!!)

    names.each do |name|
      ## todo/fix: warn about duplicates ???????
      h[name] = canonical_team_name
    end
  end
  h
end


##
##  todo/fix: change to TEAM_MAPPINGS  - why? why not?


## merge all hashes into one (TEAMS hash)
##   e.g. TEAMS = {}.merge( TEAMS_DE ).merge( TEAMS_TR )
TEAMS = [
         TEAMS_DE,
         TEAMS_MC,
         TEAMS_FR,
         TEAMS_ES,
         TEAMS_IT,
         TEAMS_NL,
         TEAMS_BE,
         TEAMS_TR
       ].reduce( {} ) { |memo,txt| memo.merge( teams_txt_to_h( txt )) }



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
