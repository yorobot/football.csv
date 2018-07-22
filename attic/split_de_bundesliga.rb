# encoding: utf-8


task :bundesliga do |t|
  ## all bundesliga seasons in a single .csv file e.g.
  ##    Bundesliga_1963_2014.csv
  ##  assumes the following fields/header
  ##  - Spielzeit;Saison;Spieltag;Datum;Uhrzeit;Heim;Gast;Ergebnis;Halbzeit
  ##  e.g.
  ## 1;1963-1964;1;1963-08-24;17:00;Werder Bremen;Borussia Dortmund;3:2;1:1
  ## 1;1963-1964;1;1963-08-24;17:00;1. FC Saarbruecken;1. FC Koeln;0:2;0:2

  #
  # note: separator is semi-colon (e.g. ;)


  in_path = './dl/Bundesliga_1963_2014.csv'

  ## try a dry test run
##  i = 0
##  CSV.foreach( in_path, headers: true, col_sep: ';' ) do |row|
##    i += 1
##    print '.' if i % 100 == 0
##  end
##  puts " #{i} rows"


  ### convert to "standard" format and
  ##   use new folder structure

  i = 0

  last_num    = 0
  last_season = ''
  last_round  = 0

  match_count = 0

  schedule = []

  out_root = './o/de-deutschland'
  league  = '1-bundesliga'
  headers = ['Round','Date','Team 1','Team 2','FT','HT']

  CSV.foreach( in_path, headers: true, col_sep: ';' ) do |row|
    i += 1
    print '.' if i % 100 == 0

    num    = row['Spielzeit'].to_i
    season = row['Saison']
    round  = row['Spieltag'].to_i

    date   = row['Datum']
    time   = row['Uhrzeit']

    team1 = row['Heim']
    team2 = row['Gast']

    ## reformat team if match  (e.g. Bayern Munich => Bayern München etc.)
    team1 = TEAMS[ team1 ]   if TEAMS[ team1 ]
    team2 = TEAMS[ team2 ]   if TEAMS[ team2 ]

    ft = row['Ergebnis'].tr(':','-')
    ht = row['Halbzeit'].tr(':','-')


    if last_num > 0 && num != last_num

      save_season( out_root, league, last_season, headers, schedule )

      ## puts "[debug] begin new season #{num} #{season}"

      match_count = 0
      schedule    = []
    end

    ## note: do NOT add time
    schedule << [round,date,team1,team2,ft,ht]
    match_count += 1

    last_num    = num
    last_season = season
    last_round  = round
  end  # each row

  # note: do NOT forget last season
  save_season( out_root, league, last_season, headers, schedule )

  puts 'done'
end
