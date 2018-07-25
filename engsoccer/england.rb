# encoding: utf-8

require 'csv'
require 'pp'

require './import/lib/read'

team_mappings = SportDb::Import.config.team_mappings
known_teams   = SportDb::Import.config.teams


##### todo: check if date missing and how often
###   [x] - done - no (0) missing date!!


##### todo: check if season if always moving forward (sorted)
##### todo: check half time (ht) ??
###     add csv headers here
#
#  #<CSV::Row
#        "":        "1"
#        "Date":    "1888-12-15"
#        "Season":  "1888"
#        "home":    "Accrington F.C."
#        "visitor": "Aston Villa"
#        "FT":      "1-1"
#        "hgoal":   "1"
#        "vgoal":   "1"
#        "division":"1"
#        "tier":    "1"
#        "totgoal": "2"
#        "goaldif": "0"
#        "result":"  D">


path = './dl/engsoccerdata/data-raw/england.csv'

## 194_040 rows
# divs:
#  {"1"=>47910,
#   "2"=>51940,
#   "3"=>33030, "3a"=>14386, "3b"=>14580,
#   "4"=>32194}
# tiers:
#  {"1"=>47910,
#   "2"=>51940,
#   "3"=>61996,
#   "4"=>32194}

divs  = Hash.new(0)
tiers = Hash.new(0)
teams = Hash.new(0)
seasons = Hash.new(0)
scores  = Hash.new(0)

missing_dates = []



last_year = nil
last_tier = -1

i = 0
CSV.foreach( path, headers: true ) do |row|
  i += 1

  if i == 1
    pp row
  end

  print '.' if i % 100 == 0



  divs[row['division']]  += 1
  tiers[row['tier']] += 1

  teams[row['home']] += 1
  teams[row['visitor']] += 1

  seasons[row['Season']] += 1

  scores[row['FT']] += 1

  date = row['Date']
  if date.empty? || date == 'NA'
    puts "*** missing date in row: #{row.inspect}"
    missing_dates << row
  end


  ### assert / validate order of records for (fast) splitting
  year = row['Season'].to_i
  if last_year && last_year > year
    puts "*** error: season out-of-order in row #{i}: #{row.inspect}"
    exit 1
  end

  ### assert tier is always upward
  tier = row['tier'].to_i
  if last_year && last_year == year && tier < last_tier
    puts "*** warn: fix!!! tier out-of-order in row #{i}: #{row.inspect}"
    ## exit 1
  end


  ## double check scores

    ft     = row['FT']
    ## note: for now round, and ht (half-time) results are always missing

    ## todo/fix: check format with regex !!!
    score = ft.split('-')   ## todo/check - only working if always has score?!
    score1 = score[0].to_i
    score2 = score[1].to_i

    if row['hgoal'].to_i != score1 ||
       row['vgoal'].to_i != score2
      puts "*** error: ft scores corrupt in row #{i}: #{row.inspect}"
      exit 1
    end

  last_year = year
  last_tier = tier
end


puts " #{i} rows"

puts "#{divs.size} divs:"
pp divs

puts "#{tiers.size} tiers:"
pp tiers

puts "#{seasons.size} seasons:"
pp seasons

puts "#{missing_dates.size} missing dates:"
pp missing_dates

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
pp unknown_teams
## pp unknown_teams.to_a

## sort unknown_teams by match_count
puts "sorted by match count:"
sorted_teams = unknown_teams.to_a.sort { |l,r| r[1] <=> l[1] }

pp sorted_teams


puts "#{scores.size} scores:"
pp scores
