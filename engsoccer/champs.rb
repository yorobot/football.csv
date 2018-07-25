# encoding: utf-8

require 'csv'
require 'pp'

require './import/lib/read'

team_mappings = SportDb::Import.config.team_mappings
known_teams   = SportDb::Import.config.teams



path = './dl/engsoccerdata/data-raw/champs.csv'

rounds    = Hash.new(0)
legs      = Hash.new(0)
teams     = Hash.new(0)
seasons   = Hash.new(0)
scores    = Hash.new(0)
countries = Hash.new(0)
missing_dates = []


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

61 seasons:
{"1955"=>29,
 "1956"=>44,
 "1957"=>48,
 "1958"=>55,
 "1959"=>52,
 "1960"=>51,
 "1961"=>55,
 "1962"=>59,
 "1963"=>61,
 "1964"=>63,
 "1965"=>59,
 "1966"=>65,
 "1967"=>60,
 "1968"=>52,
 "1969"=>63,
 "1970"=>63,
 "1971"=>63,
 "1972"=>57,
 "1973"=>60,
 "1974"=>55,
 "1975"=>61,
 "1976"=>61,
 "1977"=>59,
 "1978"=>63,
 "1979"=>63,
 "1980"=>63,
 "1981"=>63,
 "1982"=>59,
 "1983"=>59,
 "1984"=>61,
 "1985"=>59,
 "1986"=>57,
 "1987"=>61,
 "1988"=>59,
 "1989"=>61,
 "1990"=>59,
 "1991"=>73,
 "1992"=>82,
 "1993"=>95,
 "1994"=>77,
 "1995"=>77,
 "1996"=>77,
 "1997"=>147,
 "1998"=>149,
 "1999"=>235,
 "2000"=>237,
 "2001"=>237,
 "2002"=>237,
 "2003"=>205,
 "2004"=>205,
 "2005"=>209,
 "2006"=>207,
 "2007"=>213,
 "2008"=>213,
 "2009"=>213,
 "2010"=>213,
 "2011"=>213,
 "2012"=>213,
 "2013"=>213,
 "2014"=>215,
 "2015"=>217}

53 countries:
{"POR"=>567,
 "SRB"=>222,
 "HUN"=>225,
 "BEL"=>394,
 "SUI"=>285,
 "ESP"=>1112,
 "GER"=>983,
 "SCO"=>385,
 "SWE"=>259,
 "POL"=>226,
 "DEN"=>249,
 "FRA"=>653,
 "AUT"=>286,
 "NED"=>489,
 "ITA"=>915,
 "LUX"=>130,
 "ROU"=>289,
 "TUR"=>368,
 "SVK"=>134,
 "ENG"=>992,
 "BUL"=>220,
 "NIR"=>133,
 "IRL"=>134,
 "CZE"=>285,
 "CRO"=>160,
 "FIN"=>164,
 "GRE"=>381,
 "NOR"=>236,
 "MLT"=>120,
 "ALB"=>96,
 "CYP"=>178,
 "ISL"=>114,
 "RUS"=>316,
 "UKR"=>352,
 "BIH"=>54,
 "ARM"=>56,
 "GEO"=>64,
 "BLR"=>104,
 "MKD"=>56,
 "SVN"=>76,
 "EST"=>52,
 "FRO"=>48,
 "LVA"=>70,
 "ISR"=>122,
 "LTU"=>62,
 "WAL"=>44,
 "MDA"=>80,
 "AZE"=>50,
 "KAZ"=>48,
 "MNE"=>24,
 "SMR"=>18,
 "AND"=>22,
 "GIB"=>6}
=end


i = 0
CSV.foreach( path, headers: true ) do |row|
  i += 1

  if i == 1
    pp row
  end

  print '.' if i % 100 == 0

  rounds[row['round']] += 1
  legs[row['leg']]     += 1


  teams[row['home']] += 1
  teams[row['visitor']] += 1

  countries[row['hcountry']] += 1
  countries[row['vcountry']] += 1

  scores[row['FT']] += 1

  seasons[row['Season']] += 1

  date = row['Date']
  if date.empty? || date == 'NA'
    puts "*** missing date in row: #{row.inspect}"
    missing_dates << row
  end
end


puts " #{i} rows"

puts "#{legs.size} legs:"
pp legs

puts "#{rounds.size} rounds:"
pp rounds

puts "#{seasons.size} seasons:"
pp seasons

puts "#{scores.size} scores:"
pp scores

puts "#{missing_dates.size} missing dates:"
pp missing_dates

puts "#{countries.size} countries:"
pp countries

puts "#{teams.size} teams:"
pp teams


### check for unknown teams
unknown_teams = {}
teams.each do |team,match_count|
    ## note: do NOT forget to check known_teams (1:1) mapping too!!!! (to avoid duplicate mappings)
    if team_mappings[ team ] || known_teams[ team ]
      # do nothing
    else
      unknown_teams[team] = match_count
    end
end


puts "#{unknown_teams.size} unknown teams:"
## pp unknown_teams
## pp unknown_teams.to_a

## sort unknown_teams by match_count
puts "sorted by match count:"
sorted_teams = unknown_teams.to_a.sort { |l,r| r[1] <=> l[1] }

pp sorted_teams
