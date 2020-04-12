####
#  tidy up all-time records for clubs

require 'pp'


txt = File.open( './tmp/champs.transfermarkt.txt', 'r:utf-8').read
txt = txt.tr( "\t", ' ' )   ## norm first as single line

## remove (diss. 2004) markers - why? why not?


pp txt


###
# Pos 	Club	Matches W D L  GD   Points
#
# 1	Real Madrid	Real Madrid	436	260	76	100	490	856

re_transfermarkt = /\b
         (?<pos>\d+) 
       [ ]+
         (?<club>.+)       ## note: use greedy!!!
       [ ]+
         (?<pld>\d+)
       [ ]+
         (?<w>\d+)
       [ ]+
         (?<d>\d+)
       [ ]+
         (?<l>\d+)
       [ ]+
         (?<gd>-?\d+)   ## note: may start with a minus (-)!
       [ ]+
         (?<pts>\d+)
       \b
      /x


def deduplicate( name )
  name = name.strip
  name = name.gsub( /[ ]{2,}/, ' ' )  ## squish - fold more than one space into one space

  if name.size % 2 == 0
    puts "!! ERROR: odd size expected for duplicate name:"
    puts name.size
    pp name
    exit 1
  end

  length = (name.size-1) / 2
  l = name[0..length-1]
  r = name[length+1..-1]

  if l != r
    puts "!! ERROR: duplicate name mismatch:"
    pp l
    pp r
    exit 1
  end
  l
end
      

recs = [] 
txt.each_line do |line|
     line = line.strip
     next if line.empty? || line.start_with?( '#' )

     m = re_transfermarkt.match( line )
     if m.nil?
       puts "!! ERROR: cannot match line:"
       pp line
       exit 1
     end
     values = m.captures
     values[1] = deduplicate(values[1])
     recs << values
end


pp recs


puts
puts "#{recs.size} records found"


headers = %w(pos club	pld w d l gd pts)


File.open( "./champs.transfermarkt.csv", 'w:utf-8') do |f|
    f.write headers.join( ', ' )
    f.write "\n"
    recs.each do |rec|
    f.write rec.join( ', ' )
    f.write "\n"
    end
end
