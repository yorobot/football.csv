## check leagues

require 'csvreader'



require_relative 'programs'



leagues = {}    ## track league usage & names

PROGRAMS.each do |program|
   recs = CsvHash.read( "2019-#{program}.csv", :header_converters => :symbol )
   pp recs.size
   ## pp recs[0]

   recs.each do |rec|
     league_code  = rec[:liga]
     league_title = rec[:liga_title]

     if league_title =~ /Fussball/
       ## note: skip handicap tipps - team_1 or team_2 includes +1/+2/+3/+4/+5/-1/-2/-3/..
       if rec[:team_1] =~ /[+-][12345]/ ||
          rec[:team_2] =~ /[+-][12345]/
          puts "skip tip with handicap:"
          pp rec
          next
       end

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


NATIONAL_TEAM_LEAGUES = [    # note: skip (ignore) all leagues/cups/tournaments with national (selction) teams for now
  'EM Q',       # Europameisterschaft Qualifikation
  'U21 EMQ',    # U21 EM Qualifikation
  'WM Q',       # WM Qualifikation
  'INT FS',     # Internationale Freundschaftsspiele
  'FS U21',     # U21 Freundschaftsspiele
  'FS U20',     # U20 Freundschaftsspiele
  'INT FSD',    # Internationale Freundschaftsspiele, Damen
]

## mark unknown season
puts "sorted:"
sorted_leagues.each do |l|
  m = LEAGUES.match( l[0] )
  if m || NATIONAL_TEAM_LEAGUES.include?( l[0] )
    print "   "
  else
    print "!! "
  end
  puts "   #{'%3s'%l[1][0]} #{'%-8s'%l[0]} #{l[1][1]}"
end
