# encoding: utf-8

require './import/lib/read'


path = './dl/engsoccerdata/data-raw/england.csv'


headers = {
  team1:   'home',     team2: 'visitor',
  season:  'Season',
  score:   'FT',
  date:    'Date',
  divison: 'division',
  level:   'tier' }

CsvMatchReader.dump( path, headers: headers )


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


last_year = nil
last_tier = -1

i = 0
CSV.foreach( path, headers: true ) do |row|
  i += 1

  if i == 1
    pp row
  end

  print '.' if i % 100 == 0

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
