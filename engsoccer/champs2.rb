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
