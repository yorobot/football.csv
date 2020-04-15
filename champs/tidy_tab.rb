####
#  tidy up records for clubs

require 'pp'



in_path  = './tmp/uefa.clubs.kassiesa.1975.txt'
out_path = "./o/uefa.clubs.kassiesa.1975.csv"


txt = File.open( in_path, 'r:utf-8').read
txt = txt.tr( "\t", ' • ' )   ## norm first as single line

pp txt


###
#
# 1 •   • Real Madrid • Esp • 29.00 • 33.00 • 33.00 • 32.00 • 19.00 • 146.000 • 20.713


re_tab = / (?:  ^|•[ ]+  )
          (?<club>[^•]+)
          [ ]+
          •
          [ ]+
          (?<country>[a-z]{3})
          [ ]+
          •
      /xi


## hacks for old country codes (always use official FIFA codes) - why? why not?
       alt_country_codes = { 'BLS' =>  'BLR', # Belarus
                             'ROM' =>  'ROU', # Romania
                             'AZB' =>  'AZE', # Azerbaijan
                             'SLO' =>  'SVN', # Slovenia
                             'MOL' =>  'MDA', # Moldovia
                             'MAC' =>  'MKD', # Macedonia
                             'LIT' =>  'LTU', # Lithuania
                             'LAT' =>  'LVA', # Latvia
                             'FAR' =>  'FRO', # Faroe Islands
                             'MON' =>  'MNE', # Montenegro
                             'SMA' =>  'SMR', # San Marino
                             'KOS' =>  'KVX', # Kosovo
                             'BOS' =>  'BIH', # Bosnia and Herzegovina
                           }


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
               alt_country_codes[ m[:country].upcase ] || m[:country].upcase
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
