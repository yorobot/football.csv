


def write_champs_season( root:, season:, matches: )

  ## convert to season as string e.g. .
  basename = "champs"

  ## todo/fix: change directory to dirname (like FileUtils) or add alias - why? why not?
  dirname = "#{season}"
  puts "write #{basename} (#{dirname}) in #{root}"

  path = "#{root}/#{dirname}/#{basename}.csv"


  ###
  ## todo: (stable??) sort by
  #    1) date and
  #    2) group if present (e.g. A,B,C, etc.)

  matches = matches.sort do |l,r|
    res = l.date <=> r.date
    res = l.group <=> r.group  if res == 0 && l.group && r.group
    res
  end


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




  ## out_root = './o/europe-champions-league'
  out_root = '../../footballcsv/europe-champions-league'


round_mapping = {
  ##  map round to => round / stage / group

  ## note 1991/2 season first with group stage!! Use Knockout Stage if Champions league (starting in 1992/3 season)
  ## note 1994/5 season first with qualifying round (before preliminary)
  ##  => use qualifying stage starting with 1994/5 season

  ## note: shorten Preliminary to Prelim.
 "PrelimF" => ['Prelim. Round', ->(year) { year >= 1994 ? 'Qualifying' : '' }], ## 28,
 "prelim"  => ['Prelim. Round', ->(year) { year >= 1994 ? 'Qualifying' : '' }], ## 68,

 "1"      => ['Round 1'],       # 30
 "Round1" => ['Round 1'],       # 1091   ## - use qualifying stage for cl in 1993/4 ?? - why? why not?
 "Round2" => ['Round 2'],       # 48     ## - use qualifying stage for cl in 1993/4 ?? - why? why not?

  ## note: shorten Qualifying to Qual.
 "Q-1"  => ['Qual. Round 1', 'Qualifying'], # =>318,
 "Q-2"  => ['Qual. Round 2', 'Qualifying'], # =>582,
 "Q-3"  => ['Qual. Round 3', 'Qualifying'], # =>528,
 "Q-PO" => ['Playoff Round', 'Qualifying'], # =>140 -- use own playoff stage - why? why not?

 "GroupA"  => ['Matchday ?',  'Group', 'A'],
 "GroupB"  => ['Matchday ?',  'Group', 'B'],
 "GroupC"  => ['Matchday ?',  'Group', 'C'],
 "GroupD"  => ['Matchday ?',  'Group', 'D'],
 "GroupE"  => ['Matchday ?',  'Group', 'E'],
 "GroupF"  => ['Matchday ?',  'Group', 'F'],
 "GroupG"  => ['Matchday ?',  'Group', 'G'],
 "GroupH"  => ['Matchday ?',  'Group', 'H'],

  ## 1st Group Stage
 "GroupA-prelim"  => ['Matchday ?', 'Group 1st', '1|A'],  ## 48 - use just A for group - why? why not?
 "GroupB-prelim"  => ['Matchday ?', 'Group 1st', '1|B'],  ## 48
 "GroupC-prelim"  => ['Matchday ?', 'Group 1st', '1|C'],  ## 48
 "GroupD-prelim"  => ['Matchday ?', 'Group 1st', '1|D'],  ## 48
 "GroupE-prelim"  => ['Matchday ?', 'Group 1st', '1|E'],  ## 48
 "GroupF-prelim"  => ['Matchday ?', 'Group 1st', '1|F'],  ## 48
 "GroupG-prelim"  => ['Matchday ?', 'Group 1st', '1|G'],  ## 48
 "GroupH-prelim"  => ['Matchday ?', 'Group 1st', '1|H'],  ## 48
  ## 2nd Group Stage
  ##   use 2/A insteaod 2|A or A|2 or A/2 ??
 "GroupA-inter"   => ['Matchday ?', 'Group 2nd', '2|A'],  ## 48 - use just A for group - why? why not?
 "GroupB-inter"   => ['Matchday ?', 'Group 2nd', '2|B'],  ## 48
 "GroupC-inter"   => ['Matchday ?', 'Group 2nd', '2|C'],  ## 48
 "GroupD-inter"   => ['Matchday ?', 'Group 2nd', '2|D'],  ## 48

  ## note 1991/2 season first with group stage!! Use Knockout Stage if Champions league (starting in 1992/3 season)
  ## note 1994/5 season first with qualifying round (before preliminary)
  ##               and first with quarterfinals (before just final and semifinals)
  ##  => use Knockout stage starting with 1994/5 season
 "R16"    => ['Round of 16',   ->(year) { year >= 1994 ? 'Knockout' : '' }],  # =>768,
 "QF"     => ['Quarterfinals', ->(year) { year >= 1994 ? 'Knockout' : '' }],  # =>470,
 "SF"     => ['Semifinals',    ->(year) { year >= 1994 ? 'Knockout' : '' }],  # =>237,
 "final"  => ['Final',         ->(year) { year >= 1994 ? 'Knockout' : '' }],   # =>62,
}


  i = 0
  last_year = nil       ## e.g.  1996, 1997, etc.

  matches = []
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
    ## todo/fix: check format with regex !!!
    score = ft.split('-')   ## todo/check - only working if always has score?!
    score1 = score[0].to_i
    score2 = score[1].to_i

    ht     = row['HT'].strip
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

    round_str    = row['round'].strip

  r = round_mapping[ round_str ]
  if r.nil?
    puts "*** missing round mapping >#{round_str}<"
    exit 1
  end

  round = r[0]

  if r[1].is_a?( Proc )
     stage = r[1].call( year )
  else
     stage = r[1]  ## note: defaults to nil if not present
  end

  group = r[2]   ## note: defaults to nil if not present

####
#  6 legs:
#  { "NA"=>62,
#    "1"=>2137, "2"=>2136,
#    "replay"=>34, "initial"=>1,
#    "groups"=>2184}

  leg_str = row['leg'].strip

  if leg_str.empty? || leg_str == 'NA'
    leg = nil
  elsif leg_str == 'groups' || leg_str == 'initial'
    leg = nil
  elsif leg_str == 'replay'
    leg = 'Replay'    ## move to its own column or use its own replay round ??
  else
    leg = leg_str
  end


    country1  = row['hcountry'].strip
    country2  = row['vcountry'].strip


    score1agg = nil
    score2agg = nil

    ### cleanup agg - only add agg scores if leg defined
    ##   todo: include replay - why? why not?
    ##  do NOT include replay for now
    if leg ### just add for leg 1,2,3,.. for now
      ## add replays only if not group stage (incl. group 1st, group 2nd) or final
      if leg == 'Replay' &&
         ((round && round == 'Final') || (stage && stage.include?('Group')))
        ## skip adding agg score
      else
        ##  todo/fix:
        ##  check if the same ??
        ## totagg_home, totagg_visitor   => always same as FT_agg?
        ## tothgoal, totvgoal            => always same as FT score?

        ## agg1   = row['tothgoal'].strip
        agg1   = row['FTagg_home'].strip
        score1agg = (agg1.empty? || agg1 == 'NA') ? nil : agg1.to_i

        ## agg2   = row['totvgoal'].strip
        agg2   = row['FTagg_visitor'].strip
        score2agg = (agg2.empty? || agg2 == 'NA') ? nil : agg2.to_i
      end
    end


    ### todo/fix: warn
    ##   if a.e.t present   full time (ft) should be a tie/draw e.g. 2-2 not 1-2 or something!!!
    ##   note: check for leg with aggregate score!!!!

    ##
    ## todo: use aet (and split) - why? why not?

    et1 = row['aethgoal'].strip
    score1et = (et1.empty? || et1 == 'NA') ? nil : et1.to_i

    et2 = row['aetvgoal'].strip
    score2et = (et2.empty? || et2 == 'NA') ? nil : et2.to_i



    comments = nil

    p = row['pens'].strip
    if p.empty? || p == 'NA'
      score1p = score2p = nil
    elsif p =~ /^\d{1,2}-\d{1,2}$/   ## e.g. 10-11, 5-4, etc.
      score = p.split('-')
      score1p = score[0].to_i
      score2p = score[1].to_i
    else
      score1p = score2p = nil
      ##  todo/fix: check for and list "allowed" values for comments e.g.
      #   => 7
      #  => 140
      #    =>2
      if ['coin toss', 'away goals', 'walkover'].include?( p )
        ## add tie break to its own column? for now add to comments - why? why not?
         comments = p
      else
        puts "*** error: don't know how to handle unknown penalties format / value >#{p}<"
        exit 1
      end
    end


    ### todo/fix: warn
    ##   if pen(alty) present   a.e.t. should be a tie/draw e.g. 2-2 not 1-2 or something!!!
    ##   note: check for leg with aggregate score!!!!
    ##   if leg != 1  score might be not tied/drawn (but aggregate score is)



    if last_year  &&  (last_year != year)
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
      date:      date,
      team1:     team1,     team2:     team2,
      score1:    score1,    score2:    score2,
      score1i:   score1i,   score2i:   score2i,
      score1et:  score1et,  score2et:  score2et,
      score1p:   score1p,   score2p:   score2p,
      score1agg: score1agg, score2agg: score2agg,
      round:    round,
      stage:    stage,
      leg:      leg,
      group:    group,
      country1: country1, country2:  country2,
      comments: comments
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
