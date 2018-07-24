# encoding: utf-8

require 'csv'
require 'pp'


path = './dl/engsoccer/england.csv'

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

i = 0
CSV.foreach( path, headers: true ) do |row|
  i += 1
  print '.' if i % 100 == 0

  divs[row['division']]  += 1
  tiers[row['tier']] += 1

  teams[row['home']] += 1
  teams[row['visitor']] += 1
end
puts " #{i} rows"

puts "#{divs.size} divs:"
pp divs

puts "#{tiers.size} tiers:"
pp tiers

puts "#{teams.size} teams:"
pp teams
