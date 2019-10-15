
## shared list of tipp3 programs

PROGRAMS = %w[
  34a_tue-aug-20  34b_fri-aug-23
  35a_tue-aug-27  35b_fri-aug-30
  36a_tue-sep-3   36b_fri-sep-6
  37a_tue-sep-10  37b_fri-sep-13
  38a_tue-sep-17  38b_fri-sep-20
  39a_tue-sep-24  39b_fri-sep-27
  40a_tue-oct-1   40b_fri-oct-4
  41a_tue-oct-8
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
