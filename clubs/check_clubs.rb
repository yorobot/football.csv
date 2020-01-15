###
##  todo/fix: update check_clubs_by_leagues( leagues ) for new (shared) linter!!!
##    see wikipedia/check_clubs !!!!!
##
##  todo/check: check sportbild/2019-20/clubs.txt !!!


require_relative '../lint/check_clubs'




UEFA_RE = %r{
              /[a-z]{3}\.txt$
            }x

CLUB_RE = %r{
               /clubs\.txt$
            }x


# datafiles = Datafile.find( 'uefa/2019-20', UEFA_RE )
datafiles = [
 # 'espn/2019-20/ar.txt' 
 # 'espn/2019-20/at.txt' 
 # 'espn/2019-20/au.txt'
 # 'espn/2019-20/be.txt' 
 # 'espn/2019-20/br.txt' 
 # 'espn/2019-20/cn.txt' 
 # 'espn/2019-20/co.txt' 
 'espn/2019-20/gt.txt'
 # 'espn/2019-20/il.txt' 
 # 'espn/2019-20/jp.txt' 
 # 'espn/2019-20/mx.txt' 
 # 'espn/2019-20/nl.txt' 
 # 'espn/2019-20/pt.txt' 
 # 'espn/2019-20/us.txt' 
]
# datafiles = Datafile.find( 'sportbild/2019-20', CLUB_RE )
pp datafiles


datafiles.each do |datafile|

  nodes = SportDb::Import::ClubLinter.read( datafile )
  pp nodes

  count = check_clubs_by_leagues( nodes )
  pp count

  if count == 0
    puts "** OK"
  else
    puts "** !!! ERROR !!! #{count} club name(s) missing"
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
