
require 'sportdb/config'


## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"
SportDb::Import.config.leagues_dir = "../../../openfootball/leagues"



LEAGUES   = SportDb::Import.config.leagues
CLUBS     = SportDb::Import.config.clubs
COUNTRIES = SportDb::Import.config.countries




class ClubLintReader   ### todo/check: rename to EventConfigReader/TournamentReader/etc. - find a better name? why? why not?

  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end

  def self.parse( txt )
    leagues = []
    league  = nil   ## current league
    clubs   = nil   ## current clubs array   ## note: same as league[1]

    txt.each_line do |line|
      line = line.strip

      next  if line.empty?
      break if line == '__END__'

      next if line.start_with?( '#' )   ## skip comments too

      ## strip inline (until end-of-line) comments too
      ##  e.g  ţ  t  ## U+0163
      ##   =>  ţ  t
      line = line.sub( /#.*/, '' ).strip


      next if line =~ /^={1,}$/          ## skip "decorative" only heading e.g. ========

      ## note: like in wikimedia markup (and markdown) all optional trailing ==== too
      ##  todo/check:  allow ===  Text  =-=-=-=-=-=   too - why? why not?
      if line =~ /^(={1,})       ## leading ======
                  ([^=]+?)      ##  text   (note: for now no "inline" = allowed)
                  =*            ## (optional) trailing ====
                  $/x
        heading_marker = $1
        heading_level  = $1.length   ## count number of = for heading level
        heading        = $2.strip

        puts "heading #{heading_level} >#{heading}<"

        if heading_level != 1
          puts "** !! ERROR !! unsupported heading level; expected heading 1 for now only; sorry"
          pp line
          exit 1
        else
          puts "heading (#{heading_level}) >#{heading}<"
          ## todo/fix: strip/remove season if present first
          clubs = []
          league  = [ heading, clubs ]
          leagues << league
        end
      else
        ##  assume club name
        ## check if starts with number e.g.   1   Liverpool
        line = line.sub( /^[0-9]{1,2}[ ]+/, '' )   if line =~ /^[0-9]{1,2}[ ]+/

        if clubs
          clubs << line
        else
          puts "** !!! ERROR !!! league heading missing / expected; cannot add club; sorry - add heading"
          exit 1
        end
      end
    end
    leagues
  end # method parse

end # class ClubLintReader




def check_clubs( names, league )
  missing_clubs = []

  country = league.country

  names.each do |name|

    m = CLUBS.match_by( name: name, country: country )

    if m.nil?
      ## (re)try with second country - quick hacks for known leagues
      m = CLUBS.match_by( name: name, country: COUNTRIES['wal'])  if country.key == 'eng'
      m = CLUBS.match_by( name: name, country: COUNTRIES['nir'])  if country.key == 'ie'
      m = CLUBS.match_by( name: name, country: COUNTRIES['mc'])   if country.key == 'fr'
      m = CLUBS.match_by( name: name, country: COUNTRIES['li'])   if country.key == 'ch'
      m = CLUBS.match_by( name: name, country: COUNTRIES['ca'])   if country.key == 'us'
    end

    if m.nil?
       puts "** !!! WARN !!! no match for club >#{name}<"

       missing_clubs << name
    elsif m.size > 1
       puts "** !!! ERROR !!! too many matches (#{m.size}) for club >#{name}<:"
       pp m
       exit 1
    else
       # bingo; match
    end
  end
  missing_clubs
end


def check_leagues( leagues )
  missing_clubs = []

  leagues.each do |rec|
    league_name = rec[0]
    club_names  = rec[1]

    m = LEAGUES.match( league_name )
    if m.nil?
      puts "!!! error [event reader] - unknown league  >#{league_name}< - sorry - add league to config to fix"
      exit 1
    else   ## todo/fix: check for more than one match error too!!!
      league = m[0]
    end

    missing = check_clubs( club_names, league )
    missing_clubs << [league_name, missing]
  end
  missing_clubs
end


UEFA_PATTERN = %r{/[a-z]{3}.txt$}

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

if __FILE__ == $0

datafiles = find_datafiles( 'uefa/2019-20', UEFA_PATTERN )
datafiles.each do |datafile|

  leagues = ClubLintReader.read( datafile )
  pp leagues

  missing_clubs = check_leagues( leagues )
  pp missing_clubs

  if missing_clubs[0][1].empty?
    puts "** OK"
  else
    puts "** !!! ERROR !!! club names missing"
    exit 1
  end
end

=begin
## path = 'orf/2019-20/ned.txt'
## path = 'bbc/2019-20/sco.txt'
path = 'uefa/2019-20/cze.txt'
leagues = ClubLintReader.read( path )
pp leagues

missing_clubs = check_leagues( leagues )
pp missing_clubs
=end

end
