####
#  tidy up all-time records for clubs

require 'pp'

in_path  = './tmp/champs.txt'
out_path = './o/champs.csv'


txt = File.open( in_path, 'r:utf-8').read

txt = txt.gsub( /[ ]{2,}/, ' ' )  ## squish - fold more than one space into one space
txt = txt.tr( "\n", ' ' )   ## norm first as single line

pp txt

###
# Pos Club Country Part Titles Pld W D L F A Pts GD
# 1 Real Madrid CF ESP    50 13 438 262 76 100 972 478 600 494 
# 2 FC Bayern München GER 36 5 348 202 72 74 708 347 476 361

# Note: Two points are awarded for a win, one point for a draw.
# Key
# Pos  - Position
# Part - Number of participations
# Pld  - Matches played
# W    - Matches won
# D    - Matches drawn
# L    - Matches lost
# F    - Goals for
# A    - Goals against
# Pts  - Points
# GD   - Goal difference


re = /   \b
         (?<pos>\d+) 
       [ ]+
        (?<club>.+?)       ## non-greedy
       [ ]+
         (?<country>[A-Z]{3})
       [ ]+
         (?<part>\d+)     # part(icipation count)
       [ ]+
         (?<titles>\d+)
       [ ]+
         (?<pld>\d+)
       [ ]+
         (?<w>\d+)
       [ ]+
         (?<d>\d+)
       [ ]+
         (?<l>\d+)
       [ ]+
         (?<f>\d+)
       [ ]+
         (?<a>\d+)
       [ ]+
         (?<pts>\d+)
       [ ]+
         (?<gd>-?\d+)   ## note: may start with a minus (-)!
       \b
      /x

#


recs = [] 
txt.scan( re) do |_|
   m = $~   # last match data
   puts "#{m[:pos]}  #{m[:club]} > #{m[:country]}"
   recs << m.captures 
end

puts
puts "#{recs.size} records found"


headers = %w(pos club country part titles pld w d l f a pts gd)
## pp recs

File.open( out_path, 'w:utf-8') do |f|
    f.write headers.join( ', ' )
    f.write "\n"
    recs.each do |rec|
    f.write rec.join( ', ' )
    f.write "\n"
    end
end
