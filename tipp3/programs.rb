
## shared list of tipp3 programs

# note: 44b_sat-nov-2 starts on a saturday!
PROGRAMS = %w[
  34a_tue-aug-20  34b_fri-aug-23
  35a_tue-aug-27  35b_fri-aug-30
  36a_tue-sep-3   36b_fri-sep-6
  37a_tue-sep-10  37b_fri-sep-13
  38a_tue-sep-17  38b_fri-sep-20
  39a_tue-sep-24  39b_fri-sep-27
  40a_tue-oct-1   40b_fri-oct-4
  41a_tue-oct-8   41b_fri-oct-11
  42a_tue-oct-15  42b_fri-oct-18
  43a_tue-oct-22  43b_fri-oct-25
  44a_tue-oct-29  44b_sat-nov-2
  45a_tue-nov-5   45b_fri-nov-8
  46a_tue-nov-12  46b_fri-nov-15
  47a_tue-nov-19  47b_fri-nov-22
  48a_tue-nov-26  48b_fri-nov-29
  49a_tue-dec-3   49b_fri-dec-6
  50a_tue-dec-10  50b_fri-dec-13
  51a_tue-dec-17  51b_fri-dec-20
  52a_mon-dec-23  52b_fri-dec-27
]


## national teams and/or women leagues
EXCLUDE_LEAGUES = [    # note: skip (ignore) all leagues/cups/tournaments with national (selction) teams for now
  'WM Q',       # WM Qualifikation
  'EM Q',       # Europameisterschaft Qualifikation
  'U21 EMQ',    # U21 EM Qualifikation
  'U19 EMQ',    # U19 EM Qualifikation
  'INT FS',     # Internationale Freundschaftsspiele
  'FS U21',     # U21 Freundschaftsspiele
  'FS U20',     # U20 Freundschaftsspiele

  ## national leagues (women)
  'INT FSD',    # Internationale Freundschaftsspiele, Damen
  'EMQDA',      # EM Qualifikation, Damen
  'U19 DAQ',    # U19 EM Frauen, Qualifikation
  ## todo/fix: move to clubs leagues (women) - why? why not?
  'CL DAM',     # UEFA Champions League Damen
  'AUT DA',     # Österreich Frauen Bundesliga
]
