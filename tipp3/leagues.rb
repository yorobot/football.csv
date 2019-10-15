## check leagues

require 'csvreader'



require_relative 'programs'



leagues = {}    ## track league usage & names

PROGRAMS.each do |program|
   recs = CsvHash.read( "o/2019-#{program}.csv", :header_converters => :symbol )
   pp recs.size
   ## pp recs[0]

   recs.each do |rec|
     league_code  = rec[:liga]
     league_title = rec[:liga_title]

     if league_title =~ /Fussball/
       league_title = league_title.sub('Fussball - ','')
       puts "#{league_code} | #{league_title}"

       leagues[ league_code ] ||= [0, league_title]
       leagues[ league_code ][0] += 1
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



require 'sportdb/config'

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"
SportDb::Import.config.leagues_dir = "../../../openfootball/leagues"

LEAGUES = SportDb::Import.config.leagues



## mark unknown season
puts "sorted (#{sorted_leagues.size}) - #{PROGRAMS.join(' ')}:"
sorted_leagues.each do |l|
  m = LEAGUES.match( l[0] )
  if m
    print "    "
  elsif EXCLUDE_LEAGUES.include?( l[0] )
    print "(*) "   ## skip national (selection) team leagues and/or women leagues for now
  else
    print "!!! "
  end
  puts "   #{'%3s'%l[1][0]} #{'%-8s'%l[0]} #{l[1][1]}"
end
puts
puts "(*): national team and/or women leagues - #{EXCLUDE_LEAGUES.sort.join(', ')}"
