# encoding: utf-8

require 'sportdb/config'

SportDb::Import.config.clubs_dir = '../../openfootball/clubs'



recs = read_csv( './clubs/clubs2.txt' )
pp recs
pp recs.size

rec = recs[0]
pp rec[:rank]
pp rec[:name]
pp rec[:country]


###
# check for matching club names


club_index    = SportDb::Import.config.clubs
country_index = SportDb::Import.config.countries


missing = []


recs.each do |rec|
  pp rec

  name    = rec[:name]
  country = rec[:country]
  pp name

  clubs = club_index.match_by( name: name, country: country )
  pp clubs
  if clubs
    if clubs.size > 1
      puts "** !! ERROR !! too many matches, found #{clubs.size} clubs"
      exit 1
    end
  else
    puts "** !! ERROR !! no matching club found >#{name}<, #{country}"
    missing << [name, country]
  end
end


puts "#{missing.size} missing clubs:"
pp missing

missing_by_country = missing.group_by { |item| item[1] }

puts missing_by_country.pretty_inspect

missing_by_country.each do |k,v|
  country = country_index[k]
  puts "= #{country.name} (#{country.key})  #{country.fifa}    ##{v.size} clubs:"
  v.each do |item|
    puts item[0]
  end
  puts
end
