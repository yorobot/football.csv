require_relative 'boot'


LEAGUES   = SportDb::Import.config.leagues
CLUBS     = SportDb::Import.config.clubs
COUNTRIES = SportDb::Import.config.countries



class Names
  def initialize( country_key )
    @names = Hash.new(0)

    @country = COUNTRIES[ country_key ]
    if @country.nil?
      puts "!! ERROR - no country found for key >#{country_key}<"
      exit 1  
    end
    pp @country
  end

  def add_matches( matches )
    matches.each do |match|
      @names[ match.team1 ] += 1
      @names[ match.team2 ] += 1 
    end
  end

  def build
    buf = String.new('')
    errors = []

    ## sort by count (reverse) and alphabet
    names = @names.sort do |l,r|
      res =  r[1] <=> l[1]
      res =  l[0] <=> r[0]  if res == 0
      res
    end

    buf << "\n\n## #{@country.name} (#{@country.key})\n\n"
    buf << "#{names.size} club names:\n\n"
    buf << "```\n"

    clubs = {}  ## check for duplicates

    names.each do |rec|
      club = CLUBS.find_by( name: rec[0], country: @country )
      if club.nil?
        puts "!! ERROR - no club match found for >#{rec[0]}<"
        errors << "#{rec[0]} > #{@country.name}"
 
        buf << "!!! #{rec[0]} (#{rec[1]})\n"
      else
        if club.historic?
          buf << "xxx "   ### check if year is in name?
        else
          buf << "    "
        end

        buf << "%-28s" %  "#{rec[0]} (#{rec[1]})"
        if club.name != rec[0]
          buf << " => %-25s |" % club.name
        else
          buf << (" #{' '*28} |")
        end  
        
        if club.city
          buf << " #{club.city}"
          buf << " (#{club.district})"   if club.district
        else
          buf << " ?  "
        end

        if club.geos
          buf << ",  #{club.geos.join(' › ')}"
        end
        
        buf << "\n"

        clubs[club] ||= []
        clubs[club] << rec[0]
      end
    end
    buf << "```\n\n"
 
    ## check for duplicate clubs (more than one mapping / name)
    duplicates = clubs.reduce( {} ) do |h,(club,rec)| 
                                      h[club]=rec  if rec.size > 1
                                      h 
                                    end
 
    if duplicates.size > 0
      buf << "\n\n#{duplicates.size} duplicates:\n"
      duplicates.each do |club, rec|
        buf << "- **#{club.name}** _(#{rec.size})_ #{rec.join(' · ')}\n"
      end
    end 

    [buf, errors]
  end
end # class Names





puts FOOTBALLDATA_SOURCES.size      #=> 11
puts FOOTBALLDATA_SOURCES_II.size   #=> 16


$buf = String.new('')
$buf << "# Summary\n\n"

$errors = []


FOOTBALLDATA_SOURCES.each do |country_key, country_sources|

  names = Names.new( country_key )
  country_sources.each do |rec|
    season_key  = rec[0]   ## note: dirname is season_key e.g. 2011-12 etc.
    basenames  = rec[1]   ## e.g. E1,E2,etc.

    basenames.each do |basename|

      path = "./dl/#{season_key}/#{basename}.csv"

      matches = CsvMatchReader.read( path )

      ## pp matches[0..2]
      pp matches.size

      names.add_matches( matches )
    end
  end
  
  buf, errors = names.build

  $buf    << buf
  $errors += errors  
end



FOOTBALLDATA_SOURCES_II.each do |country_key, country_basename|
  puts "#{country_key} #{country_key.class.name} - #{country_basename}"  

  path = "./dl/#{country_basename}.csv"

  names = Names.new( country_key )
  matches = CsvMatchReader.read( path )

  ## pp matches[0..2]
  pp matches.size

  names.add_matches( matches)
  
  buf, errors = names.build
  
  $buf    << buf
  $errors += errors
end


puts "#{$errors.size} errors:"
pp $errors

$buf << "\n\n#{$errors.size} errors:\n"
$buf << "```\n"
$buf << $errors.pretty_inspect
$buf << "\n```\n"



puts $buf

File.open( 'SUMMARY.md', 'w:utf-8' ) do |f|
  f.write $buf
end

puts "bye"