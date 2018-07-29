


def write_champs_season( root:, season:, matches: )

  ## convert to season as string e.g. .
  basename = "champs"

  ## todo/fix: change directory to dirname (like FileUtils) or add alias - why? why not?
  dirname = "#{season}"
  puts "write #{basename} (#{dirname}) in #{root}"

  path = "#{root}/#{dirname}/#{basename}.csv"

  CsvMatchWriter.write( path, matches, format: 'champs' )
end



task :champssummary do |t|
  ## root = './o'
  root = '../../footballcsv'

  report = CsvSummaryReport.new( "#{root}/europe-champions-league" )
  report.write
end


task :champs do |t|

  in_path = './dl/engsoccerdata/data-raw/champs.csv'

  i = 0
  CSV.foreach( in_path, headers: true ) do |row|
      i += 1
      print '.' if i % 100 == 0
    end
  puts " #{i} rows"



  i = 0

  last_year     = 0        ## e.g.  1996, 1997, etc.

  matches = []

  ## out_root = './o/europe-champions-league'
  out_root = '../../footballcsv/europe-champions-league'


  CSV.foreach( in_path, headers: true ) do |row|
    i += 1

    print '.' if i % 100 == 0

    ## for debuggin stop after 1000
    ## if i > 1000
    ##   exit
    ## end


    ######
    # "Date","Season","home","visitor","FT","hgoal","vgoal","hconf","vconf",
    #   "totgoal","round","leg","hgoalaet","vgoalaet","hpen","vpen"
    #  e.g 1996-04-06,1996,"San Jose Earthquakes","DC United","1-0",1,0,"West","East",
    #      1,"regular",NA,NA,NA,NA,NA


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
    ## todo/fix: check format with regex !!!
    score = ft.split('-')   ## todo/check - only working if always has score?!
    score1 = score[0].to_i
    score2 = score[1].to_i

    ht     = row['HT']
    ## todo/fix: check format with regex !!!
    score = ht.split('-')   ## todo/check - only working if always has score?!
    score1i = score[0].to_i
    score2i = score[1].to_i


=begin
   33 rounds:
   {"Round1"=>1091,
    "QF"=>470,
    "SF"=>237,
    "final"=>62,
    "R16"=>768,
    "PrelimF"=>28,
    "1"=>30,
    "Round2"=>48,
    "GroupB"=>252,
    "GroupA"=>252,
    "prelim"=>68,
    "GroupD"=>216,
    "GroupC"=>216,
    "Q-1"=>318,
    "Q-2"=>582,
    "GroupF"=>180,
    "GroupE"=>180,
    "Q-3"=>528,
    "GroupB-prelim"=>48,
    "GroupA-prelim"=>48,
    "GroupC-prelim"=>48,
    "GroupD-prelim"=>48,
    "GroupH-prelim"=>48,
    "GroupF-prelim"=>48,
    "GroupE-prelim"=>48,
    "GroupG-prelim"=>48,
    "GroupB-inter"=>48,
    "GroupA-inter"=>48,
    "GroupC-inter"=>48,
    "GroupD-inter"=>48,
    "GroupH"=>156,
    "GroupG"=>156,
    "Q-PO"=>140}
=end

   ## note: use '?' for undefined / unknown / missing (required) value
   ##        use nil or '-' for n/a (not/applicable)

    round_str    = row['round']

    stage = '?'
    round = round_str

####
#  6 legs:
#  { "NA"=>62,
#    "1"=>2137, "2"=>2136,
#    "replay"=>34, "initial"=>1,
#    "groups"=>2184}

    leg         = row['leg']
    leg = nil   if leg.empty? || leg == 'NA'


    country1  = row['hcountry']
    country2  = row['vcountry']


    ### todo/fix: warn
    ##   if a.e.t present   full time (ft) should be a tie/draw e.g. 2-2 not 1-2 or something!!!
    ##   note: check for leg with aggregate score!!!!

    et1 = row['aethgoal']
    if et1.empty? || et1 == 'NA'
      score1et = nil
    else
      score1et = et1.to_i
    end

    et2 = row['aetvgoal']
    if et2.empty? || et2 == 'NA'
      score2et = nil
    else
      score2et = et2.to_i
    end


=begin
    ## check - fix penalties (pens)


    ### todo/fix: warn
    ##   if pen(alty) present   a.e.t. should be a tie/draw e.g. 2-2 not 1-2 or something!!!
    ##   note: check for leg with aggregate score!!!!
    ##   if leg != 1  score might be not tied/drawn (but aggregate score is)

    p1 = row['hpen']
    if p1.empty? || p1 == 'NA'
      score1p = nil
    else
      score1p = p1.to_i
    end

    p2 = row['vpen']
    if p2.empty? || p2 == 'NA'
      score2p = nil
    else
      score2p = p2.to_i
    end
=end


    if last_year > 0  &&  (last_year != year)
      ## processs
      ##  note: convert season to string

      last_season = "%4d-%02d" % [last_year,(last_year+1)%100]

      write_champs_season( root:    out_root,
                           season:  last_season,
                           matches: matches )

      if last_year != year
        puts "[debug] begin new season #{year}"
      end

      matches    = []
    end

    match = SportDb::Struct::Match::new(
      date:     date,
      team1:    team1,    team2:    team2,
      score1:   score1,   score2:   score2,
      score1i:  score1i,  score2i:  score2i,
      score1et: score1et, score2et: score2et,
      ## score1p:  score1p,  score2p:  score2p,
      round:  round,
      stage:  stage,
      leg:    leg,
      country1:  country1,      country2:  country2
    )
    matches << match

    last_year      = year
  end


  ## save last season (too)
  last_season = "%4d-%02d" % [last_year,(last_year+1)%100]  ## e.g. 2011-12 or 1999-00

  write_champs_season( root:    out_root,
                       season:  last_season,
                       matches: matches )

  puts "done"
end
