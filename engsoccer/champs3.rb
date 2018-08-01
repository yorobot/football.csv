# encoding: utf-8

require './import/lib/read'


path = './dl/engsoccerdata/data-raw/champs.csv'


=begin
6 legs:
{"1"       => 2137,
 "2"       => 2136,
 "NA"      => 62,

## fix - 34 replays agg scores
##  find prev 2nd leg
##    change score!!  subtract replay!!!!
##      should be 3-3 or 4-4 etc.!!!! thus, replay/playoff required
##
##  skip replay in final (only one match - no legs)

 "replay"  => 34,
 "initial" => 1,
 "groups"  => 2184}
=end


##
#  first row:
#<CSV::Row
#   "Date":"1955-09-04"
#   "Season":"1955"
#   "round":"Round1"
#   "leg":"1"
#   "home":"Sporting CP"
#   "visitor":"Partizan Belgade"
#   "FT":"3-3"
#   "HT":"1-1"
#   "aet":"NA"
#   "pens":"NA"
#   "hgoal":"3"
#   "vgoal":"3"
#   "FTagg_home":"5"
#   "FTagg_visitor":"8"
#   "aethgoa":"NA"
#   "aetvgoal":"NA"
#   "tothgoal":"3"
#   "totvgoal":"3"
#   "totagg_home":"5"
#   "totagg_visitor":"8"
#   "tiewinner":"Partizan Belgrde"
#   "hcountry":"POR"
#   "vcountry":"SRB">

=begin
6 legs:
{"1"       => 2137,
 "2"       => 2136,
 "NA"      => 62,
 "replay"  => 34,
 "initial" => 1,
 "groups"  => 2184}

33 rounds:
{"Round1"  =>1091,
 "QF"      =>470,
 "SF"      =>237,
 "final"   =>62,
 "R16"     =>768,
 "PrelimF" =>28,
 "1"       =>30,
 "Round2"  =>48,
 "GroupB"  =>252,
 "GroupA"  =>252,
 "prelim"  =>68,
 "GroupD"  =>216,
 "GroupC"  =>216,
 "Q-1"     =>318,
 "Q-2"     =>582,
 "GroupF"  =>180,
 "GroupE"  =>180,
 "Q-3"     =>528,
 "GroupB-prelim" =>48,
 "GroupA-prelim" =>48,
 "GroupC-prelim" =>48,
 "GroupD-prelim" =>48,
 "GroupH-prelim" =>48,
 "GroupF-prelim" =>48,
 "GroupE-prelim" =>48,
 "GroupG-prelim" =>48,
 "GroupB-inter"  =>48,
 "GroupA-inter"  =>48,
 "GroupC-inter"  =>48,
 "GroupD-inter"  =>48,
 "GroupH"   =>156,
 "GroupG"   =>156,
 "Q-PO"     =>140}

{"pens"=>
  {"NA"=>6348,
   "coin toss"=>7,
   "away goals"=>140,
   "4-3 "=>3,
   "4-5 "=>2,
   "3-4"=>4,
   "1-2 "=>1,
   "1-4 "=>2,
   "3-0 "=>2,
   "5-4 "=>3,
   "4-2"=>3,
   "3-5 "=>1,
   "2-0"=>1,
   "1-3 "=>2,
   "6-5"=>3,
   "2-4 "=>1,
   "5-3 "=>1,
   "walkover"=>2,
   "5-3"=>2,
   "10-11"=>1,
   "1-3"=>1,
   "3-2"=>3,
   "5-4"=>3,
   "4-1"=>2,
   "2-4"=>1,
   "4-2 "=>1,
   "4-3"=>4,
   "4-1 "=>1,
   "2-3 "=>1,
   "6-7 "=>1,
   "9-8"=>1,
   "5-6"=>1,
   "2-3"=>1,
   "4-5"=>1,
   "3-2 "=>1,
   "8-7 "=>1}}
=end



def score_equal?( col, col1, col2 )
  ### check if aet and aethgoal/aetvgoal are equal

  if col.empty? || col == 'NA'
    score1 = score2 = nil
  else
    score1, score2 = col.split('-')
  end

  exp_score1 = (col1.empty? || col1 == 'NA') ? nil : col1
  exp_score2 = (col2.empty? || col2 == 'NA') ? nil : col2

  (exp_score1 == score1 && exp_score2 == score2) ? true : false
end


values = {}

last_year = nil

i = 0
CSV.foreach( path, headers: true ) do |row|
  i += 1

  if i == 1
    pp row
  end

  print '.' if i % 100 == 0

  year       = row['Season'].strip.to_i
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



  values['leg'] ||= Hash.new(0)
  values['leg'][ leg ] +=1


  ## note: score1 + score1et = total
  ##

  values['diff'] ||= Hash.new(0)
  if score1 != tot1 || score2 != tot2
     if aet1 != tot1 || aet2 != tot2
       values['diff']['score <=> tot'] +=1
     end

     values['diff']['score-NA'] +=1  if score1 == 'NA' || score2 == 'NA' || tot1 == 'NA' || tot2 == 'NA'
  end
  if agg1 != totagg1 || agg2 != totagg2

     if totagg1.to_i != (agg1.to_i+(aet1.to_i-score1.to_i))  ||
        totagg2.to_i != (agg2.to_i+(aet2.to_i-score2.to_i))

       values['diff']['agg2 <=> totagg2'] +=1
       buf = ''
       buf << "#{year} | "

      buf << "#{score1}-#{score2} / "
      buf << "#{tot1}-#{tot2} "    ## tot = score + aet
      buf << "#{aet1}-#{aet2} aet "

       buf << "#{agg1}-#{agg2} agg. / "
       buf << "#{totagg1}-#{totagg2} "
       buf << "=> #{round} - #{leg} - #{team1} #{team2}"
       puts buf
     end
     values['diff']['agg2-NA'] +=1  if agg1 == 'NA' || agg2 == 'NA' || totagg1 == 'NA' || totagg2 == 'NA'
  end



  if leg == 'replay'
    values['replay'] ||= []

    buf = ''
    buf << "#{year} | "

    buf << "#{score1}-#{score2} / "
    buf << "#{tot1}-#{tot2} "    ## tot = score + aet

    if score1 != tot1 || score2 != tot2
      buf << "#{aet1}-#{aet2} aet "
      buf << " <== !!!!!    "
    end


    buf << "| "

    if agg1 != totagg1 || agg2 != totagg2
      buf << "    !!!!! => "
    end

    buf << "#{agg1}-#{agg2} agg. / "
    buf << "#{totagg1}-#{totagg2} "
    buf << "=> #{round} - #{leg} - #{team1} #{team2}"

    values['replay'] << buf
  end

=begin
 "replay"=>
  ["1956 - Round1 - replay - Borussia Dortmund Spora Luxemburg",
   "1956 - R16 - replay - OGC Nice Rangers",
   "1956 - R16 - replay - Real Madrid Rapid Wien",
   "1957 - Round1 - replay - SC Wismut Karl-Marx-Stadt Gwardia Warszawa",
   "1957 - Round1 - replay - AC Milan Rapid Wien",
   "1957 - R16 - replay - Borussia Dortmund CCA Bucuresti",
   "1958 - Round1 - replay - Schalke 04 KB Kobenhavn",
   "1958 - Round1 - replay - SC Wismut Karl-Marx-Stadt Petrolul Ploiesti",
   "1958 - Round1 - replay - IFK Goteborg Jeunesse Esch",
   "1958 - R16 - replay - Atletico Madrid CDNA Sofia",
   "1958 - QF - replay - BSC Young Boys SC Wismut Karl-Marx-Stadt",
   "1958 - SF - replay - Real Madrid Atletico Madrid",
   "1959 - R16 - replay - Sparta Rotterdam IFK Goteborg",
   "1959 - R16 - replay - OGC Nice Fenerbahce",
   "1959 - QF - replay - Rangers Sparta Rotterdam",
   "1960 - R16 - replay - Rapid Wien SC Wismut Karl-Marx-Stadt",
   "1960 - SF - replay - Barcelona Hamburger SV",
   "1961 - QF - replay - Real Madrid Juventus",
   "1962 - Round1 - replay - Feyenoord Servette Geneve",
   "1962 - R16 - replay - Feyenoord Budapesti Vasas",
   "1963 - Round1 - replay - Austria Wien Gornik Zabrze",
   "1963 - R16 - replay - FC Zurich Galatasaray",
   "1964 - Round1 - replay - RSC Anderlecht Bologna",
   "1964 - Round1 - replay - Dukla Praha Gornik Zabrze",
   "1964 - Round1 - replay - Rangers Crvena Zvezda",
   "1964 - QF - replay - Liverpool Koln",
   "1966 - Round1 - replay - Liverpool Petrolul Ploiesti",
   "1966 - Round1 - replay - Gornik Zabrze ASK Vorwarts Berlin",
   "1966 - R16 - replay - Atletico Madrid Vojvodina",
   "1966 - SF - replay - Internazionale CSKA Sofia",
   "1967 - QF - replay - Juventus Eintracht Braunschweig",
   "1968 - QF - replay - AFC Ajax SL Benfica",
   "1973 - final - replay - Bayern Munich Atletico Madrid",
   "1992 - Round1 - replay - VfB Stuttgart Leeds United"]}
=end


# "tothgoal","totvgoal"   -- what do they mean / what used for???
# "totagg_home","totagg_visitor"


  ############
  ## fix/todo:
  ##  make it a method for reuse!!!
  ##   to (double) check scores!!!

  ### check if aet and aethgoal/aetvgoal are equal
  if score_equal?( row['FT'], row['hgoal'], row['vgoal'] ) == false
    puts "\n\n** error: score mismatch - FT <=> hgoal, vgoal:"
    pp row['FT']
    pp row['hgoal']
    pp row['vgoal']
    exit 1
  end

  if score_equal?( row['aet'], row['aethgoal'], row['aetvgoal'] ) == false
    puts "\n\n** error: score mismatch aet <=> aethgoal, aetvgoal:"
    pp row['aet']
    pp row['aethgoal']
    pp row['aetvgoal']
    exit 1
  end


=begin
33 rounds:
{"Round1"  =>1091,
 "QF"      =>470,
 "SF"      =>237,
 "final"   =>62,
 "R16"     =>768,
 "PrelimF" =>28,
 "1"       =>30,
 "Round2"  =>48,
 "GroupB"  =>252,
 "GroupA"  =>252,
 "prelim"  =>68,
 "GroupD"  =>216,
 "GroupC"  =>216,
 "Q-1"     =>318,
 "Q-2"     =>582,
 "GroupF"  =>180,
 "GroupE"  =>180,
 "Q-3"     =>528,
 "GroupB-prelim" =>48,
 "GroupA-prelim" =>48,
 "GroupC-prelim" =>48,
 "GroupD-prelim" =>48,
 "GroupH-prelim" =>48,
 "GroupF-prelim" =>48,
 "GroupE-prelim" =>48,
 "GroupG-prelim" =>48,
 "GroupB-inter"  =>48,
 "GroupA-inter"  =>48,
 "GroupC-inter"  =>48,
 "GroupD-inter"  =>48,
 "GroupH"   =>156,
 "GroupG"   =>156,
 "Q-PO"     =>140}

6 legs:
{"1"       => 2137,
 "2"       => 2136,
 "NA"      => 62,
 "replay"  => 34,
 "initial" => 1,
 "groups"  => 2184}
=end



=begin
{"1"       => 2137,
 "2"       => 2136,
 "NA"      => 62,
 "replay"  => 34,
 "initial" => 1,
 "groups"  => 2184}
=end


=begin
columns:
"aet","pens",
"hgoal","vgoal",
"FTagg_home","FTagg_visitor",
"aethgoal","aetvgoal",
"tothgoal","totvgoal",
"totagg_home","totagg_visitor",
"tiewinner",
"hcountry","vcountry"
=end


  last_year = year
end

pp values

puts "\nOK. Done. Bye."
