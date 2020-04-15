####
#  check all clubs from all-time records

require_relative 'boot'


# in_path = './o/champs.csv'
# in_path = './o/europa.csv'
in_path = "./o/uefa.clubs.kassiesa.1975.csv"


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

alt_country_codes = { 'GDR' => 'GER' }

## check countries
total = 0
clubs_by_country.each do |country_key, club_names|


  ## skip old countries for now
  ## TCH  - Old Czech Slovak Republic  - split into 2 countries
  ## YUG  - Yuguslavia                 - split into x countries
  ## URS  - Soviet Union               - split into x countries
  ## GDR  - German Democratic Republic

  ## todo/fix: use ??? or XXX for search without country - why? why not?

  country_key = alt_country_codes[country_key] || country_key

  if ['TCH',
      'YUG',
      'URS'].include?( country_key )
        puts "skipping historic country >#{country_key}< and #{club_names.size} clubs:"
        pp club_names
        next
  end

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


puts
puts "#{total} total error(s)"

puts "bye"