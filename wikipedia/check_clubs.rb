
require_relative '../lint/check_clubs'



WIKI_PATTERN = %r{
                  /[a-z]+\.clubs\.txt$
                 }x


File.open( 'missing_clubs.txt', 'w:utf-8' ) do |out|

datafiles = find_datafiles( '.', WIKI_PATTERN )
datafiles.each do |datafile|

  countries = ClubLintReader.read( datafile )
  pp countries

  missing_clubs = check_clubs_by_countries( countries )
  pp missing_clubs

  missing_clubs.each do |rec|
     if rec[1].empty?
        puts "** OK >#{rec[0]}<"
     else
        puts "** !!! ERROR !!! #{rec[1].size} club names missing >#{rec[0]}<"
        ## exit 1

        out.puts
        out.puts "=========="
        out.puts rec[0]
        out.puts
        rec[1].each do |name|
          out.puts name
        end
     end
  end
end
end  ## File.open
