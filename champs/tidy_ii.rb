####
#  tidy up all-time records for clubs

require 'pp'

in_path  = './tmp/clubs.europe.footballdatabase.txt'
out_path = './o/clubs.europe.footballdatabase.csv'


txt = File.open( in_path, 'r:utf-8').read

txt = txt.tr( "\t", ' ' )

## remove empty lines
txt = txt.gsub( /\n{2,}/, "\n" )  ## remove empty lines
puts ">>#{txt}<<"

txt = txt.gsub( "\n", ' • ' )   ## norm first as single line
txt = txt.gsub( /[ ]{2,}/, ' ' )  ## squish - fold more than one space into one space

## some cleanup
[
 '(SRB)', '(POL)',
 '(BLR)', '(ITA)', '(GER)', '(LTU)',
 '(NOR)', '(BEL)', '(POR)',
 '(BUL)', '(WAL)', '(GEO)',
 '(IRL)', '(ISR)', '(BIH)',
].each do |word|
  txt = txt.gsub( word, '' )
end

puts txt


###
# Rank  Club / Country  Points  1-yr change
# 1  Liverpool FC   England  2023  3 1943
# 2  Bayern München  Germany  2006  5  1925


re = /   \b
         (?<pos>\d+)
       [ ]+
        •
       [ ]+
        (?<club>[^•]+)
       [ ]+
        •
       [ ]+
         (?<country>[^0-9•]+)
       [ ]+
         (?<pts>\d+)
       [ ]+
         (?<diff>\d+)
       [ ]+
         •
       [ ]+
         (?<pts_prev>\d+)
       \b
      /x



recs = []
txt.scan( re) do |_|
   m = $~   # last match data
   puts "#{m[:pos]} | #{m[:club]} › #{m[:country]}"

   next  if ['Mexico',
             'Guatemala',
             'Iran',
             'Costa Rica',
             'Nigeria',
             'Zimbabwe',
             'Honduras',
             'El Salvador',].include?( m[:country] )

   recs << [m[:pos],
            m[:club],
            m[:country]
           ]
end

puts
puts "#{recs.size} records found"


headers = %w(pos club country)
## pp recs

File.open( out_path, 'w:utf-8') do |f|
    f.write headers.join( ', ' )
    f.write "\n"
    recs.each do |rec|
    f.write rec.join( ', ' )
    f.write "\n"
    end
end
