####
#  check all clubs from all-time records

require_relative 'boot'


recs = read_csv( "./tmp/champs.engsoccer.csv" )
puts recs.size

## "Date","Season","round","leg","home","visitor","FT","HT","aet","pens",
## "hgoal","vgoal","FTagg_home","FTagg_visitor","aethgoal","aetvgoal",
## "tothgoal","totvgoal","totagg_home","totagg_visitor","tiewinner",
## "hcountry","vcountry"
## 1955-09-04,1955,"Round1","1","Sporting CP","Partizan Belgrade","3-3","1-1",NA,NA,3,3,5,8,NA,NA,3,3,5,8,"Partizan Belgrade","POR","SRB"


clubs_by_country = {}

recs.each do |rec|

  [[rec[:home],    rec[:hcountry]],
   [rec[:visitor], rec[:vcountry]]].each do |club|
  
    club_name   = club[0]
    country_key = club[1]

    clubs_by_country[country_key] ||= []
    clubs_by_country[country_key] << club_name      unless clubs_by_country[country_key].include?( club_name ) 

    ## puts "   #{club_name} > #{country_key}"
   end
end

pp clubs_by_country



total = 0
## check countries
clubs_by_country.each do |country_key, club_names|
  country = COUNTRIES[ country_key ]
  if country.nil?
    puts "!! ERROR - no country found for key >#{country_key}<"
    exit 1
  end

  ## todo/fix: check (possible) duplicates too!!!

  errors = 0
  puts "check #{club_names.size} club names in #{country.name} (#{country.key}):"
  club_names.each do |club_name|
    club = CLUBS.find_by( name: club_name, country: country )
    if club.nil?
        puts "!!     #{club_name}"
        errors += 1
    else
        print "   OK  #{club_name}"
        print " => #{club.name}"  if club_name != club.name
        print "\n"
    end
  end

  if errors > 0
    puts "#{errors} error(s)"
    ## exit 1
  end

  total += errors
end

puts "#{total} total error(s)"
puts "bye"