# encoding: utf-8

require 'pp'


def read( path )
  txt = File.open( path, 'r:utf-8' ).read

   i=0
   recs=[]
   club=[]

txt.each_line do |line|

  i+=1

  line = line.strip

  puts "#{i}: >#{line}<"

  next if line.empty?  ## skip empty

  if club.size==0 && (m=line.match( /^([0-9]{1,3})$/ ))   ## rank e.g. 1 or 2 or 499 etc.
    puts "ranking #{m[1]}"
    club << m[1]
  elsif club.size==1    ## assume club name
    puts "team: #{line}"
    club << line
  elsif club.size==2 && (m=line.match( /^([A-Z]{3})[ ]+/ ))  ## country (fifa) code e.g. AUT or ITA etc.
    puts "country #{m[1]}"
    club << m[1]
    recs << club
    club = []
  else
    puts "** !!! ERROR !!! - format error"
    exit 1
  end
puts "    >#{line}<"
end

  pp recs
  recs
end



recs = read( '../../uefa/clubs-dump.txt' )

File.open( './o/clubs.csv', 'w:utf-8' ) do |f|
  recs.each do |rec|
    f.write "#{rec[0]}, #{rec[1]}, #{rec[2]}\n"
  end
end
