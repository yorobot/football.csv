####
#  check all clubs from all-time records

require_relative 'boot'

# in_path = './o/champs.transfermarkt.csv'
# in_path = './o/champs.worldfootball.csv'
# in_path = './o/champs.quali.worldfootball.csv'
# in_path = './o/europa.worldfootball.csv'
in_path = './o/libertadores.worldfootball.csv'


recs = read_csv( in_path )
puts recs.size


## check countries
errors = 0
 
recs.each do |rec|
  club_name = rec[:club]

  clubs = CLUBS.match( club_name )
  if clubs.nil?
    puts "!!     #{club_name}"
    errors += 1
  elsif clubs.size == 1
    club = clubs[0]
    print "   OK  #{club_name}"
    print " => #{club.name}"  if club_name != club.name
    print ", #{club.country.name}"
    print "\n"
  else
    puts "x#{clubs.size}     #{club_name}"
    errors += 1
  end
end

puts "#{errors} error(s)"

puts "bye"
