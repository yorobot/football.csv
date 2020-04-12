####
#  tidy up all-time records for clubs

require 'pp'


txt = File.open( './tmp/champs.worldfootball.txt', 'r:utf-8').read
txt = txt.tr( "\t", ' ' )   ## norm first as single line

## remove (old) and (alt) markers - why? why not?

pp txt


###
# Pos 	Club	Matches W D L  GD   Points
#
# 1	Real Madrid	Real Madrid	436	260	76	100	490	856


## assume all club names are duplicates (e.g. Real Madrid Real Madrid)
re_duplicate = /
           \b
         (?<club>.+?)       ## note: use non-greedy!!!
          [ ]+
           \k<club>
          [ ]+
      /x

recs = [] 
txt.each_line do |line|
     line = line.strip
     next if line.empty? || line.start_with?( '#' )

     m = re_duplicate.match( line )
     if m.nil?
       puts "!! ERROR: cannot match line:"
       pp line
       exit 1
     end
     pp m.captures
     recs << m.captures
end


pp recs


puts
puts "#{recs.size} records found"



headers = %w(club)


File.open( "./champs.worldfootball.csv", 'w:utf-8') do |f|
    f.write headers.join( ', ' )
    f.write "\n"
    recs.each do |rec|
    f.write rec.join( ', ' )
    f.write "\n"
    end
end
