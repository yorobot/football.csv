


def write_mls_season( root:, year:, matches: )

  ## convert to season as string e.g. .
  basename = "1-mls"

  ## todo/fix: change directory to dirname (like FileUtils) or add alias - why? why not?
  dirname = "#{year}"
  puts "write #{basename} (#{dirname}) in #{root}"

  path = "#{root}/#{dirname}/#{basename}.csv"

  CsvMatchWriter.write( path, matches, format: 'mls' )
end



task :mlssummary do |t|
  ## root = './o'
  root = '../../footballcsv'

  report = CsvSummaryReport.new( "#{root}/major-league-soccer" )
  report.write
end


task :mls do |t|

  in_path = './dl/engsoccerdata/data-raw/mls.csv'

  i = 0
  CSV.foreach( in_path, headers: true ) do |row|
      i += 1
      print '.' if i % 100 == 0
    end
  puts " #{i} rows"



  i = 0

  last_year     = 0        ## e.g.  1996, 1997, etc.

  matches = []

  ## out_root = './o/major-league-soccer'
  out_root = '../../footballcsv/major-league-soccer'


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


    date   = row['Date'].strip

    ## date is NA? - set to -  for not known
    date = nil    if date.empty? || date == 'NA'


    year   = row['Season'].strip.to_i    ## note: it's always the season start year (only)

    team1  = row['home'].strip
    team2  = row['visitor'].strip

    ## reformat team if match  (e.g. Bayern Munich => Bayern München etc.)
    team_mappings = SportDb::Import.config.team_mappings
    team1 = team_mappings[ team1 ]   if team_mappings[ team1 ]
    team2 = team_mappings[ team2 ]   if team_mappings[ team2 ]


    ft     = row['FT'].strip
    ## note: for now round, and ht (half-time) results are always missing

    ## todo/fix: check format with regex !!!
    score = ft.split('-')   ## todo/check - only working if always has score?!
    score1 = score[0].to_i
    score2 = score[1].to_i


   ####
   #  5 rounds:
   # {"regular"=>4703, "conf_semi"=>181,  "conf_final"=>74, "mls_final"=>21, "play_in"=>16}

   ## note: use '?' for undefined / unknown / missing (required) value
   ##        use nil or '-' for n/a (not/applicable)

    round_str    = row['round'].strip

    if round_str == 'regular'
      stage = 'Regular'    ## or (s) season / regular season - why? why not?
      round = '?'
    else
      stage = 'Playoff'     ## or (p) playoffs / post season   - why? why not?
      round = round_str

      round = 'Conf. Knockout'   if round == 'play_in'
      round = 'Conf. Semifinals' if round == 'conf_semi'
      round = 'Conf. Finals'     if round == 'conf_final'
      round = 'Final'            if round == 'mls_final'    ## use Cup Final or Finals - why? why not?
    end

    #####
    #  4 legs:
    # {"NA"=>4758, "1"=>108, "2"=>108, "3"=>21}
    leg         = row['leg'].strip
    leg = nil   if leg.empty? || leg == 'NA'


    conf1  = row['hconf'].strip
    conf2  = row['vconf'].strip


    ### todo/fix: warn
    ##   if a.e.t present   full time (ft) should be a tie/draw e.g. 2-2 not 1-2 or something!!!
    ##   note: check for leg with aggregate score!!!!

    et1 = row['hgoalaet'].strip
    if et1.empty? || et1 == 'NA'
      score1et = nil
    else
      score1et = et1.to_i
    end

    et2 = row['vgoalaet'].strip
    if et2.empty? || et2 == 'NA'
      score2et = nil
    else
      score2et = et2.to_i
    end

    ### todo/fix: warn
    ##   if pen(alty) present   a.e.t. should be a tie/draw e.g. 2-2 not 1-2 or something!!!
    ##   note: check for leg with aggregate score!!!!
    ##   if leg != 1  score might be not tied/drawn (but aggregate score is)

    p1 = row['hpen'].strip
    if p1.empty? || p1 == 'NA'
      score1p = nil
    else
      score1p = p1.to_i
    end

    p2 = row['vpen'].strip
    if p2.empty? || p2 == 'NA'
      score2p = nil
    else
      score2p = p2.to_i
    end


    ##  for debugging - stop after 1894
    ## if year >= 1894
    ##  exit
    ## end


    if last_year > 0  &&  (last_year != year)
      ## processs
      ##  note: convert season to string

      write_mls_season( root:    out_root,
                        year:    last_year,
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
      score1et: score1et, score2et: score2et,
      score1p:  score1p,  score2p:  score2p,
      round:  round,
      stage:  stage,
      leg:    leg,
      conf1:  conf1,      conf2:  conf2
    )
    matches << match

    last_year      = year
  end

  ## save last season (too)
  write_mls_season( root:    out_root,
                    year:    last_year,
                    matches: matches )

  puts "done"
end
