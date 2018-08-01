# encoding: utf-8

require './import/lib/read'


path = './dl/engsoccerdata/data-raw/champs.csv'


def quick_fix_matches( matches )
  matches.map do |m|
    if m.date  == '1992-08-19' &&
       m.leg   == '2' &&
       m.round == 'PrelimF' &&
       m.team1 == 'Olimpija Ljubljana' &&
       m.team2 == 'FC Norma Tallinn'
         ## do
         m.update( leg: '1' )  ## change leg to 1
    elsif m.date  == '1992-08-19' &&
          m.leg   == '2' &&
          m.round == 'PrelimF' &&
          m.team1 == 'Valletta' &&
          m.team2 == 'Maccabi Tel Aviv'
         m.update( leg: '1' )  ## change leg to 1
    else
    end
    m
  end
end

def resolve_match_legs( matches )
  ####################
  # "resolve" legs - add agg scores for leg 2
  matches = quick_fix_matches( matches )
  matches.each do |m2|
    if m2.leg == '2'
      print "find leg 1..."

      leg1 = matches.find do |m1|
        m1.team1 == m2.team2 &&
        m1.team2 == m2.team1 &&
        m1.leg   == '1'  &&
        m1.round == m2.round
      end

      pp leg1
      if leg1
        print "Bingo!\n"
        ## add aggregated score for leg2
        ##  use full time score
        ##  - check if mismatch
      else
        print "FAIL!!!:\n"
        pp m2
        exit 1
      end
    end
  end
end




last_year = nil
matches   = []

i = 0
CSV.foreach( path, headers: true ) do |row|
  i += 1

  if i == 1
    pp row
  end

  print '.' if i % 100 == 0

  year       = row['Season'].strip.to_i
  date       = row['Date'].strip
  round      = row['round'].strip
  team1      = row['home'].strip
  team2      = row['visitor'].strip
  leg        = row['leg'].strip

  score1     = row['hgoal'].strip
  score2     = row['vgoal'].strip

  aet1    =  row['aethgoal'].strip
  aet2    =  row['aetvgoal'].strip


  tot1       = row['tothgoal'].strip    ## incl. aet if present
  tot2       = row['totvgoal'].strip

  agg1       = row['FTagg_home'].strip
  agg2       = row['FTagg_visitor'].strip
  totagg1    = row['totagg_home'].strip
  totagg2    = row['totagg_visitor'].strip



    if last_year  &&  (last_year != year)
      ## processs
      ##  note: convert season to string

      last_season = "%4d-%02d" % [last_year,(last_year+1)%100]

      resolve_match_legs( matches )

      matches    = []
    end

    match = SportDb::Struct::Match::new(
      date:     date,
      team1:    team1,    team2:    team2,
      score1:   score1,   score2:   score2,
      round:    round,
      leg:      leg
    )
    matches << match

    last_year      = year
end

resolve_match_legs ( matches )

puts "\nOK. Done. Bye."
