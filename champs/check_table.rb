####
#  check all clubs from all-time records

require_relative 'boot'


club_names = Hash.new(0)

[
  'champs.transfermarkt.csv',
  'champs.worldfootball.csv',
  'champs.quali.worldfootball.csv',
  'europa.worldfootball.csv',
  # 'libertadores.worldfootball.csv',
].each do |name|

  path = "./o/#{name}"

  recs = read_csv( path )
  puts recs.size

  recs.each do |rec|
    club_names[ rec[:club] ] += 1
  end
end



## check countries
errors = 0

club_names.each do |club_name, count|

  clubs = CLUBS.match( club_name )
  if clubs.nil?
    puts "!!    (#{count})  #{club_name}"
    errors += 1
  elsif clubs.size == 1
    club = clubs[0]
    print "   OK (#{count})  #{club_name}"
    print " => #{club.name}"  if club_name != club.name
    print ", #{club.country.name}"
    print "\n"
  else
    puts "x#{clubs.size}  (#{count})    #{club_name}"
    errors += 1
  end
end

puts "#{errors} error(s)"

puts "bye"
