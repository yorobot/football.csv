# encoding: utf-8

## note: use the local version of sportdb-source gem
$LOAD_PATH.unshift( File.expand_path( '../sportdb-source-footballdata/lib') )

require 'sportdb/match/formats'        ## working around - why needed? activerecord auto-loading?
require 'sportdb/source/footballdata'


## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"
SportDb::Import.config.leagues_dir = "../../../openfootball/leagues"

LEAGUES   = SportDb::Import.config.leagues
CLUBS     = SportDb::Import.config.clubs
COUNTRIES = SportDb::Import.config.countries


class Names
  def initialize
    @h = Hash.new(0)
  end

  def add_matches( matches )
    matches.each do |match|
      @h[ match.team1 ] += 1
      @h[ match.team2 ] += 1 
    end
  end

  def check( country: )
    errors = []

    ## sort by count (reverse) and alphabet
    names = @h.sort do |l,r|
      res =  r[1] <=> l[1]
      res =  l[0] <=> r[0]  if res == 0
      res
    end
    puts "#{names.size} club names:"
    pp names

    names.each do |rec|
      club = CLUBS.find_by( name: rec[0], country: country )
      if club.nil?
        puts "!! ERROR - no club match found for >#{rec[0]}<"
        errors << "#{rec[0]} > #{country.name}"
      end
    end
  
    errors
  end
end # class Names




puts FOOTBALLDATA_SOURCES.size      #=> 11
puts FOOTBALLDATA_SOURCES_II.size   #=> 16


errors = []

FOOTBALLDATA_SOURCES.each do |country_key, country_sources|
  country = COUNTRIES[ country_key ]
  if country.nil?
    puts "!! ERROR - no country found for key >#{country_key}<"
    exit 1  
  end
  pp country

  names = Names.new
  country_sources.each do |rec|
    season_key  = rec[0]   ## note: dirname is season_key e.g. 2011-12 etc.
    basenames  = rec[1]   ## e.g. E1,E2,etc.

    basenames.each do |basename|

      path = "./dl/#{season_key}/#{basename}.csv"

      matches = CsvMatchReader.read( path )

      ## pp matches[0..2]
      pp matches.size

      names.add_matches( matches)
    end
  end
  
  errors += names.check( country: country )
end



FOOTBALLDATA_SOURCES_II.each do |country_key, country_basename|
  country = COUNTRIES[ country_key ]
  if country.nil?
    puts "!! ERROR - no country found for key >#{country_key}<"
    exit 1  
  end
  pp country

  puts "#{country_key} #{country_key.class.name} - #{country_basename}"  

  path = "./dl/#{country_basename}.csv"

  names = Names.new
  matches = CsvMatchReader.read( path )

  ## pp matches[0..2]
  pp matches.size

  names.add_matches( matches)
  errors += names.check( country: country )
end

puts "#{errors.size} errors:"
pp errors

puts "bye"