####
#  tidy up records for clubs

require 'pp'



in_path  = './tmp/uefa.clubs.coefficient.txt'
out_path = "./o/uefa.clubs.coefficient.csv"


txt = File.open( in_path, 'r:utf-8').read
txt = txt.tr( "\t", ' • ' )   ## norm first as single line

pp txt


###
# 1 • Real Madrid • Spain • 33.000 • 33.000 • 32.000 • 19.000 • 17.000 • 134.000 • 16.671
# 2 • Atlético Madrid • Spain • 28.000 • 29.000 • 28.000 • 20.000 • 20.000 • 125.000 • 16.671


re_tab = / ^
        (?<pos>\d+)
           [ ]+
           •
           [ ]+
        (?<club>[^•]+)
           [ ]+
           •
           [ ]+
        (?<country>[^•]+)
          [ ]+
          •
      /x


recs = []
txt.each_line do |line|
     line = line.strip
     next if line.empty? || line.start_with?( '#' )

     line = line.gsub( /[ ]{2,}/, ' ' )  ## squish - fold more than one space into one space


     m = re_tab.match( line )
     if m.nil?
       puts "!! WARN: skipping line (cannot match): >#{line}<"
     else
       ## pp m.captures
       rec = [
               m[:club],
               m[:country]
             ]

       recs << rec
     end
end


pp recs


puts
puts "#{recs.size} records found"



headers = %w(club country)



File.open( out_path, 'w:utf-8') do |f|
    f.write headers.join( ', ' )
    f.write "\n"
    recs.each do |rec|
    f.write rec.join( ', ' )
    f.write "\n"
    end
end
