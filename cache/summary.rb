require_relative 'boot'


COUNTRIES = SportDb::Import.catalog.countries
LEAGUES   = SportDb::Import.catalog.leagues
CLUBS     = SportDb::Import.catalog.clubs



class Names
  def initialize( country_key )
    @names = Hash.new(0)

    @country = COUNTRIES.find( country_key )
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




DATA_DIR = "../../../footballcsv/cache.leagues"

datafiles = Dir[ "#{DATA_DIR}/**/*.csv" ]
puts "#{datafiles.size} datafiles"


countries = {}
datafiles.each do |datafile|
  basename = File.basename( datafile, File.extname( datafile ))
  country_key = basename.gsub( /[0-9.]/, '' )    # remove numbers and dots

  countries[ country_key] ||= Names.new( country_key )
  names = countries[ country_key]

  matches = SportDb::CsvMatchParser.read( datafile )

  pp matches.size
  pp matches[0..2]

  names.add_matches( matches )
end



errors = []
buf = String.new('')
buf << "# Summary\n\n"
buf << "#{datafiles.size} datafiles\n\n"

countries.each do |country_key, names|
  more_buf, more_errors = names.build

  buf    << more_buf
  errors += more_errors
end


puts "#{errors.size} errors:"
pp errors

if errors.size > 0
  buf << "\n\n#{errors.size} errors:\n"
  buf << "```\n"
  buf << errors.pretty_inspect
  buf << "\n```\n"
end


File.open( "./o/SUMMARY.md", 'w:utf-8' ) do |f|
  f.write buf
end

puts "bye"