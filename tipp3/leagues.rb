## check leagues

require 'csvreader'



require_relative 'programs'



leagues = {}    ## track league usage & names

PROGRAMS.each do |program|
   recs = CsvHash.read( "2019-#{program}.csv", :header_converters => :symbol )
   pp recs.size
   ## pp recs[0]

   recs.each do |rec|
     league       = rec[:liga]
     league_title = rec[:liga_title]

     if league_title =~ /Fussball/
       ## note: skip handicap tipps - team_1 or team_2 includes +1 or +2
       if rec[:team_1] =~ /\+[12]/ ||
          rec[:team_2] =~ /\+[12]/
          puts "skip tip with handicap:"
          pp rec
          next
       end

       league_title = league_title.sub('Fussball - ','')
       puts "#{league} | #{league_title}"

       leagues[ league ] ||= [0, league_title]
       leagues[ league ][0] += 1
     else
       ## skip Handball, Tennis, Hockey etc.
     end
   end
end

sorted_leagues = leagues.to_a.sort do |l,r|
  ## sort by 1) counter 2) league a-z code
  res = r[1][0] <=> l[1][0]
  res = l[0] <=> r[0]     if res == 0
  res
end

puts "sorted:"
sorted_leagues.each do |l|
  puts "#{'%3s'%l[1][0]} #{'%-8s'%l[0]} #{l[1][1]}"
end
