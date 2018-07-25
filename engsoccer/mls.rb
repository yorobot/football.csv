# encoding: utf-8

require 'csv'
require 'pp'



path = './dl/engsoccerdata/data-raw/mls.csv'

confs   = Hash.new(0)
rounds  = Hash.new(0)
legs    = Hash.new(0)
teams   = Hash.new(0)
seasons = Hash.new(0)
scores  = Hash.new(0)
missing_dates = []


##
#  first row:
#<CSV::Row
#   "Date":     "1996-04-06"
#   "Season":   "1996"
#   "home":     "San Jose Earthquakes"
#   "visitor":  "DC United"
#   "FT":       "1-0"
#   "hgoal":    "1"
#   "vgoal":    "0"
#   "hconf":    "West"
#   "vconf":    "East"
#   "totgoal":  "1"
#   "round":    "regular"
#   "leg":      "NA"
#   "hgoalaet": "NA"
#   "vgoalaet": "NA"
#   "hpen":     "NA"
#   "vpen":     "NA">

=begin
3 confs:
{"West"    => 4829,
 "East"    => 4905,
 "Central" => 256}

4 legs:
{"NA" => 4758,
 "1"  => 108,
 "2"  => 108,
 "3"  => 21}

5 rounds:
{"regular"    => 4703,
 "conf_semi"  => 181,
 "conf_final" => 74,
 "mls_final"  => 21,
 "play_in"    => 16}

21 seasons:
{"1996"=>177,
 "1997"=>173,
 "1998"=>206,
 "1999"=>208,
 "2000"=>209,
 "2001"=>176,
 "2002"=>157,
 "2003"=>161,
 "2004"=>161,
 "2005"=>204,
 "2006"=>203,
 "2007"=>206,
 "2008"=>221,
 "2009"=>236,
 "2010"=>251,
 "2011"=>319,
 "2012"=>338,
 "2013"=>338,
 "2014"=>337,
 "2015"=>357,
 "2016"=>357}
=end

i = 0
CSV.foreach( path, headers: true ) do |row|
  i += 1

  if i == 1
    pp row
  end

  print '.' if i % 100 == 0

  confs[row['hconf']] += 1
  confs[row['vconf']] += 1

  rounds[row['round']] += 1
  legs[row['leg']]     += 1


  teams[row['home']] += 1
  teams[row['visitor']] += 1

  scores[row['FT']] += 1

  seasons[row['Season']] += 1

  date = row['Date']
  if date.empty? || date == 'NA'
    puts "*** missing date in row: #{row.inspect}"
    missing_dates << row
  end
end


puts " #{i} rows"

puts "#{confs.size} confs:"
pp confs

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

puts "#{teams.size} teams:"
pp teams
