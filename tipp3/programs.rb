
## shared list of tipp3 programs

PROGRAMS = %w[
  34a 34b
  35a 35b
  36a 36b
  37a
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
