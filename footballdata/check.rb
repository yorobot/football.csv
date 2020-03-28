# encoding: utf-8

## note: use the local version of sportdb-source gem
$LOAD_PATH.unshift( File.expand_path( './sportdb-source-footballdata/lib') )

require 'sportdb/match/formats'        ## working around - why needed? activerecord auto-loading?
require 'sportdb/source/footballdata'


## use (switch to) "external" datasets
# SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"
# SportDb::Import.config.leagues_dir = "../../../openfootball/leagues"

LEAGUES   = SportDb::Import.config.leagues
CLUBS     = SportDb::Import.config.clubs
COUNTRIES = SportDb::Import.config.countries




def collect_names( matches )
  names = Hash.new(0)
  matches.each do |match|
    names[ match.team1 ] += 1
    names[ match.team2 ] += 1 
  end

  ## sort by count (reverse) and alphabet
  names.sort do |l,r|
    res =  r[1] <=> l[1]
    res =  l[0] <=> r[0]  if res == 0
    res
  end
end


puts FOOTBALLDATA_SOURCES_II.size   #=> 16


errors = []

FOOTBALLDATA_SOURCES_II.each do |country_key, country_basename|
  puts "#{country_key} #{country_key.class.name} - #{country_basename}"  

  path = "./dl/#{country_basename}.csv"

  matches = CsvMatchReader.read( path )

  ## pp matches[0..2]
  pp matches.size
  names = collect_names( matches )
  pp names

  country = COUNTRIES[ country_key ]
  if country.nil?
    puts "!! ERROR - no country found for key >#{country_key}<"
    exit 1  
  end
  pp country

  names.each do |rec|
    club = CLUBS.find_by( name: rec[0], country: country )
    if club.nil?
        puts "!! ERROR - no club match found for >#{rec[0]}<"
        errors << "#{rec[0]} > #{country.name}"
    end
  end
end

puts "#{errors.size} errors:"
pp errors

puts "bye"