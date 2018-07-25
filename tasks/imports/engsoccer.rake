# encoding: utf-8


task :engsummary do |t|
  ## root = './o'
  root = '../../footballcsv'

  pack = CsvPackage.new( 'eng-england', path: root )
  ## pp pack.find_entries_by_season

  report = CsvSummaryReport.new( pack )
  report.write
end


##
## fix/todo: sort matches by date before saving/writing!!!!

task :engsoccer do |t|
  ###
  ## Date,Season,home,visitor,FT,hgoal,vgoal,division,tier,totgoal,goaldif,result
  ##  NA,1888,"Aston Villa","Accrington F.C.","4-3",4,3,"1",1,7,1,"H"
  ##  NA,1888,"Blackburn Rovers","Accrington F.C.","5-5",5,5,"1",1,10,0,"D"


  in_path = './dl/engsoccerdata/data-raw/england.csv'

  ## try a dry test run

##  i = 0
##  CSV.foreach( in_path, headers: true ) do |row|
##    i += 1
##    print '.' if i % 100 == 0
##  end
##  puts " #{i} rows"


  i = 0

  last_year     = 0        ## e.g.  1889, 1911, etc.
  last_tier     = 0        ## e.g.  1,2,3
  last_division = ''       ## e.g.  '1','2','3','3a','3b',etc.

  match_count = 0

  matches = []

  ## out_root = './o/eng-england2'
  out_root = '../../footballcsv/eng-england'


  CSV.foreach( in_path, headers: true ) do |row|
    i += 1

    print '.' if i % 100 == 0

    ## for debuggin stop after 1000
    ## if i > 1000
    ##   exit
    ## end


    date   = row['Date']

    ## date is NA? - set to -  for not known
    date = nil    if date.empty? || date == 'NA'


    year   = row['Season'].to_i    ## note: it's always the season start year (only)

    team1  = row['home']
    team2  = row['visitor']

    ## reformat team if match  (e.g. Bayern Munich => Bayern München etc.)
    team_mappings = SportDb::Import.config.team_mappings
    team1 = team_mappings[ team1 ]   if team_mappings[ team1 ]
    team2 = team_mappings[ team2 ]   if team_mappings[ team2 ]


    ft     = row['FT']
    ## note: for now round, and ht (half-time) results are always missing

    ## todo/fix: check format with regex !!!
    score = ft.split('-')   ## todo/check - only working if always has score?!
    score1 = score[0].to_i
    score2 = score[1].to_i


    division = row['division']  # e.g. '1','2', '3a', '3b', ??
    tier     = row['tier'].to_i    # e.g. 1,2,3

    ###
    #  for now skip all season starting 1993/14
    if year >= 1993
      print '.' if i % 100 == 0
      next
    end

    ##  for debugging - stop after 1894
    ## if year >= 1894
    ##  exit
    ## end


    if last_division != '' && (last_division != division || last_year != year)

      ## processs
      ##  note: convert season to string

      ## get league name e.g eng1  => 1-division1 or 1-premierleague  depending on year (seasons starting year)
      ##                     eng3a => 1-division3n (north) etc.

      ## convert to season as string e.g. 1899 to 1899-00 or 1911 to 1911-12 etc.
      last_season = "%4d-%02d" % [last_year, (last_year+1)%100]

      basename = LeagueUtils.basename( last_division,
                                       country: 'eng',
                                       season:  last_season )

      directory = SeasonUtils.directory( last_season, format: 'long' )
      puts "write #{basename} (#{directory}) in #{out_root}"

      out_path = "#{out_root}/#{directory}/#{basename}.csv"
      ## make sure parent folders exist
      FileUtils.mkdir_p( File.dirname(out_path) )  unless Dir.exists?( File.dirname( out_path ))

      ##  save_season
      CsvMatchWriter.write( out_path, matches )

      if last_year != year
        puts "[debug] begin new season #{year}"
      end

      puts "[debug]   -- begin new division #{year} #{division} #{tier}"
      puts row.inspect    ## for debugging dump first row

      match_count = 0
      matches    = []
    end

    match = SportDb::Struct::Match::new(
      date:   date,
      team1:  team1,
      team2:  team2,
      score1: score1,
      score2: score2
    )
    matches << match


    match_count += 1

    last_year      = year
    last_tier      = tier
    last_division  = division
  end

  puts 'done'
end
