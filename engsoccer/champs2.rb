# encoding: utf-8

require './import/lib/read'


path = './dl/engsoccerdata/data-raw/champs.csv'


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




round_mapping = {
  ##  map round to => round / stage / group

 "PrelimF" => ['Preliminary Round', ->(year) { year >= 1992 ? 'Qualifying' : '' }], ## 28,
 "prelim"  => ['Preliminary Round', ->(year) { year >= 1992 ? 'Qualifying' : '' }], ## 68,

 "1"      => ['Round 1'],       # 30
 "Round1" => ['Round 1'],       # 1091   ## - use qualifying stage for cl in 1993/4 ?? - why? why not?
 "Round2" => ['Round 2'],       # 48     ## - use qualifying stage for cl in 1993/4 ?? - why? why not?

 "Q-1"  => ['Qualifying Round 1', 'Qualifying'], # =>318,
 "Q-2"  => ['Qualifying Round 2', 'Qualifying'], # =>582,
 "Q-3"  => ['Qualifying Round 3', 'Qualifying'], # =>528,
 "Q-PO" => ['Playoff Round',      'Qualifying'], # =>140 -- use own playoff stage - why? why not?

 "GroupA"  => ['Matchday ?',  'Group', 'A'],
 "GroupB"  => ['Matchday ?',  'Group', 'B'],
 "GroupC"  => ['Matchday ?',  'Group', 'C'],
 "GroupD"  => ['Matchday ?',  'Group', 'D'],
 "GroupE"  => ['Matchday ?',  'Group', 'E'],
 "GroupF"  => ['Matchday ?',  'Group', 'F'],
 "GroupG"  => ['Matchday ?',  'Group', 'G'],
 "GroupH"  => ['Matchday ?',  'Group', 'H'],

  ## 1st Group Stage
 "GroupA-prelim"  => ['Matchday ?', 'Group 1st', '1/A'],  ## 48 - use just A for group - why? why not?
 "GroupB-prelim"  => ['Matchday ?', 'Group 1st', '1/B'],  ## 48
 "GroupC-prelim"  => ['Matchday ?', 'Group 1st', '1/C'],  ## 48
 "GroupD-prelim"  => ['Matchday ?', 'Group 1st', '1/D'],  ## 48
 "GroupE-prelim"  => ['Matchday ?', 'Group 1st', '1/E'],  ## 48
 "GroupF-prelim"  => ['Matchday ?', 'Group 1st', '1/F'],  ## 48
 "GroupG-prelim"  => ['Matchday ?', 'Group 1st', '1/G'],  ## 48
 "GroupH-prelim"  => ['Matchday ?', 'Group 1st', '1/H'],  ## 48
  ## 2nd Group Stage
 "GroupA-inter"   => ['Matchday ?', 'Group 2nd', '2/A'],  ## 48 - use just A for group - why? why not?
 "GroupB-inter"   => ['Matchday ?', 'Group 2nd', '2/B'],  ## 48
 "GroupC-inter"   => ['Matchday ?', 'Group 2nd', '2/C'],  ## 48
 "GroupD-inter"   => ['Matchday ?', 'Group 2nd', '2/D'],  ## 48

  ## Use Knockout Stage if Champions league (starting in 1992/3 season)
 "R16"    => ['Round of 16',   ->(year) { year >= 1992 ? 'Knockout' : '' }],  # =>768,
 "QF"     => ['Quarterfinals', ->(year) { year >= 1992 ? 'Knockout' : '' }],  # =>470,
 "SF"     => ['Semifinals',    ->(year) { year >= 1992 ? 'Knockout' : '' }],  # =>237,
 "final"  => ['Final',         ->(year) { year >= 1992 ? 'Knockout' : '' }],   # =>62,
}



values = {}

last_year = nil

i = 0
CSV.foreach( path, headers: true ) do |row|
  i += 1

  if i == 1
    pp row
  end

  print '.' if i % 100 == 0

  ### todo/fix: auto-add to all csv files!!!!!
  ### assert / validate order of records for (fast) splitting
  year = row['Season'].to_i
  if last_year && last_year > year
    puts "\n\n*** error: season out-of-order in row #{i}: #{row.inspect}"
    exit 1
  end

  values['pens'] ||= Hash.new(0)
  values['pens'][ row['pens'] ] +=1

  values['aet'] ||= Hash.new(0)
  values['aet'][ row['aet'] ] +=1

  values['FTagg_home'] ||= Hash.new(0)
  values['FTagg_home'][ row['FTagg_home'] ] +=1

  values['FTagg_visitor'] ||= Hash.new(0)
  values['FTagg_visitor'][ row['FTagg_visitor'] ] +=1

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

  year       = row['Season'].strip.to_i
  round_str  = row['round'].strip


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


  pens_str = row['pens'].strip
  if pens_str.empty? || pens_str == 'NA'
    pen = nil
  elsif pens_str =~ /^\d{1,2}-\d{1,2}$/   ## e.g. 10-11, 5-4, etc.
    pen = pens_str
  else
    puts "*** warn/todo/fix: handle penalties >#{pens_str}<"
    pen = nil
  end

=begin
{"1"       => 2137,
 "2"       => 2136,
 "NA"      => 62,
 "replay"  => 34,
 "initial" => 1,
 "groups"  => 2184}
=end


=begin
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
