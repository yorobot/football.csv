# encoding: utf-8


task :engsoccer do |t|
  ###
  ## Date,Season,home,visitor,FT,hgoal,vgoal,division,tier,totgoal,goaldif,result
  ##  NA,1888,"Aston Villa","Accrington F.C.","4-3",4,3,"1",1,7,1,"H"
  ##  NA,1888,"Blackburn Rovers","Accrington F.C.","5-5",5,5,"1",1,10,0,"D"


  in_path = './dl/engsoccerdata.csv'

  ## try a dry test run

##  i = 0
##  CSV.foreach( in_path, headers: true ) do |row|
##    i += 1
##    print '.' if i % 100 == 0
##  end
##  puts " #{i} rows"


  i = 0

  last_season   = 0
  last_division = ''
  last_tier     = 0

  match_count = 0

  schedule = []

  out_root = './o/en-england'
  headers  = ['Date','Team 1','Team 2','FT']

  CSV.foreach( in_path, headers: true ) do |row|
    i += 1

    ### print '.' if i % 100 == 0

    date   = row['Date']
    season = row['Season'].to_i
    team1  = row['home']
    team2  = row['visitor']

    ## reformat team if match  (e.g. Bayern Munich => Bayern München etc.)
    team1 = TEAMS[ team1 ]   if TEAMS[ team1 ]
    team2 = TEAMS[ team2 ]   if TEAMS[ team2 ]

    ## date is NA? - set to -  for not known
    date =  '-'  if date == 'NA'

    ft     = row['FT']

    division = row['division']  # e.g. 1,2, 3a, 3b, 3c ??
    tier     = row['tier'].to_i    # e.g. 1,2,3

    ###
    #  for now skip all season starting 1993/14
    if season >= 1993
      print '.' if i % 100 == 0
      next
    end

    ##  for debugging - stop after 1894
    ## if season >= 1894
    ##  exit 
    ## end


    if last_division != '' && (last_division != division || last_season != season)

      ## processs
      ##  note: convert season to string
      if last_tier == 1 || last_tier == 2
         ## note: skip tier 3,4 for now
         ### fix: add missing tiers!!!!

         ## get league name e.g eng1  => 1-division1 or 1-premierleague  depending on year (seasons starting year)
         year = last_season
         league = get_league( 'en-england', year, "eng#{last_tier}" )

         save_season( out_root, league, last_season.to_s, headers, schedule )
      end


      if last_season != season
        puts "[debug] begin new season #{season}"
      end

      puts "[debug]   -- begin new division #{season} #{division} #{tier}"
      puts row.inspect    ## for debugging dump first row

      match_count = 0
      schedule    = []
    end

    schedule << [date,team1,team2,ft]

    match_count += 1

    last_season    = season
    last_division  = division
    last_tier      = tier
  end

  puts 'done'
end
