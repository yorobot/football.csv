
## shared list of tipp3 programs

PROGRAMS = %w[
  34a 34b       ## Tu-Th Aug/20-22 +++ Fr-Mo Aug/23-26
  35a 35b       ## Tu-Th Aug/27-29 +++ Fr-Mo Aug/30-Sep/2
  36a 36b       ## Tu-Th Sep/3-5   +++ Fr-Mo Sep/6-9
  37a 37b       ## Tu-Th Sep/10-12 +++ Fr-Mo Sep/13-16
  38a 38b       ## Tu-Th Sep/17-19 +++ Fr-Mo Sep/20-23
  39a 39b       ## Tu-Th Sep/24-26 +++ Fr-Mo Sep/27-30
  40a 40b       ## Tu-Th Oct/1-3   +++ Fr-Mo Oct/4-7
  41a           ## Tu-Th Oct/8-10   
]


## todo/fix: rename to EXCLUDE_LEAGUES - why? why not?
NATIONAL_TEAM_LEAGUES = [    # note: skip (ignore) all leagues/cups/tournaments with national (selction) teams for now
  'EM Q',       # Europameisterschaft Qualifikation
  'U21 EMQ',    # U21 EM Qualifikation
  'WM Q',       # WM Qualifikation
  'INT FS',     # Internationale Freundschaftsspiele
  'FS U21',     # U21 Freundschaftsspiele
  'FS U20',     # U20 Freundschaftsspiele
  ## national leagues (women)
  'INT FSD',    # Internationale Freundschaftsspiele, Damen
  'EMQDA',      # EM Qualifikation, Damen
  ## todo/fix: move to clubs leagues (women) - why? why not?
  'CL DAM',     # UEFA Champions League Damen
]
