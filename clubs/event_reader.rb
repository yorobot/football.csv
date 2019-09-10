
require 'sportdb/config'


## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"
SportDb::Import.config.leagues_dir = "../../../openfootball/leagues"



LEAGUES = SportDb::Import.config.leagues
LEAGUES.dump_duplicates

CLUBS     = SportDb::Import.config.clubs

COUNTRIES = SportDb::Import.config.countries




class EventReader   ### todo/check: rename to EventConfigReader/TournamentReader/etc. - find a better name? why? why not?

  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end

  def self.parse( txt )
    ## todo/fix: move match teams out-of parse; return recs - why? why not?
    missing_clubs = {}

    league   = nil    # last league

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
          m = LEAGUES.match( heading )
          league = m[0]    ## todo/fix: check for more than one match error too!!!
          if league.nil?
            puts "!!! error [event reader] - unknown league  >#{heading}< - sorry - add league to config to fix"
            exit 1
          end
        end
      else
        ## assume "regular" line  with club name

        name    = line
        country = league.country

        m = CLUBS.match_by( name: name, country: country )

        if m.nil? && league.national?
          ## (re)try with second country - quick hacks for known leagues
          m = CLUBS.match_by( name: name, country: COUNTRIES['wal'])  if country.key == 'eng'
          m = CLUBS.match_by( name: name, country: COUNTRIES['mc'])   if country.key == 'fr'
          m = CLUBS.match_by( name: name, country: COUNTRIES['li'])   if country.key == 'ch'
          m = CLUBS.match_by( name: name, country: COUNTRIES['ca'])   if country.key == 'us'
        end

        if m.nil?
           puts "** !!! WARN !!! no match for club <#{name}>"

           missing_clubs[ league.key ] ||= []
           missing_clubs[ league.key ] << name
        elsif m.size > 1
           puts "** !!! ERROR !!! too many matches (#{m.size}) for club <#{name}>:"
           pp m
           exit 1
        else
           # bingo; match
        end
      end
      ## pp line
    end
    pp missing_clubs
  end # method parse

end # class EventReader



if __FILE__ == $0

EventReader.read( 'bbc/2019-20.txt' )

end
