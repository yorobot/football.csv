
require 'sportdb/config'
require 'wikiscript'

COUNTRIES = SportDb::Import.config.countries

## todo/check - move find_datafiles to sportdb-countries/config for (re)use - why? why not?
def find_datafiles( path, pattern )
  datafiles = []
  candidates = Dir.glob( "#{path}/**/*.txt" ) ## check all txt files as candidates
  pp candidates
  candidates.each do |candidate|
    datafiles << candidate    if pattern.match( candidate )
  end

  pp datafiles
  datafiles
end



CLUBS_PATTERN = %r{
                  /[a-z]+\.txt$
                 }x


datafiles = find_datafiles( './dl', CLUBS_PATTERN )
datafiles.each do |datafile|
  page = Wikiscript.read( datafile )
  ## pp page.parse

  puts
  puts "** #{datafile}"
  page.each do |node|
    if node[0] == :h2
      country = COUNTRIES.parse( node[1] )
      if country
        print "OK "
      end
      puts node[1]
    end
  end
end
