
require_relative '../lint/check_clubs'



RSSSF_PATTERN = %r{
                  /[a-z]{2,3}.txt$
                 }x


File.open( 'missing_clubs.txt', 'w:utf-8' ) do |out|

datafiles = find_datafiles( '2018-19', RSSSF_PATTERN )
datafiles.each do |datafile|

  countries = ClubLintReader.read( datafile )
  pp countries

  missing_clubs = check_clubs_by_countries( countries )
  pp missing_clubs

  if missing_clubs[0][1].empty?
    puts "** OK"
  else
    puts "** !!! ERROR !!! club names missing"
    ## exit 1

    out.puts
    out.puts "=========="
    out.puts missing_clubs[0][0]
    out.puts
    missing_clubs[0][1].each do |name|
      out.puts name
    end
  end
end
end  ## File.open
