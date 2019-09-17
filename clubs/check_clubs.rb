
require_relative '../lint/check_clubs'




UEFA_PATTERN = %r{
                  /[a-z]{3}.txt$
                 }x

datafiles = find_datafiles( 'uefa/2019-20', UEFA_PATTERN )
datafiles.each do |datafile|

  leagues = ClubLintReader.read( datafile )
  pp leagues

  missing_clubs = check_clubs_by_leagues( leagues )
  pp missing_clubs

  if missing_clubs[0][1].empty?
    puts "** OK"
  else
    puts "** !!! ERROR !!! club names missing"
    exit 1
  end
end


__END__

## path = 'orf/2019-20/ned.txt'
## path = 'bbc/2019-20/sco.txt'
path = 'uefa/2019-20/cze.txt'
leagues = ClubLintReader.read( path )
pp leagues

missing_clubs = check_leagues( leagues )
pp missing_clubs
