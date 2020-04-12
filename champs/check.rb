####
#  check all clubs from all-time records

require_relative 'boot'


# in_path = './o/champs.csv'
in_path = './o/europa.csv'


recs = read_csv( in_path )
puts recs.size

clubs_by_country = {}

recs.each do |rec|
  pos         = rec[:pos]
  club_name   = rec[:club]
  country_key = rec[:country]

  clubs_by_country[country_key] ||= []
  clubs_by_country[country_key] << club_name

  puts "#{pos}  #{club_name} > #{country_key}"
end

pp clubs_by_country

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
end


puts "bye"