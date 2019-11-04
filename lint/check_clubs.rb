
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
    headings = []
    clubs   = nil   ## current clubs array   ## note: same as headings[-1][1]

    txt.each_line do |line|
      line = line.strip

      next  if line.empty?
      break if line == '__END__'

      next if line.start_with?( '#' )   ## skip comments too

      ## strip inline (until end-of-line) comments too
      ##  e.g  ţ  t  ## U+0163
      ##   =>  ţ  t
      line = line.sub( /#.*/, '' ).strip


      next if line =~ /^[ =]+$/          ## skip "decorative" only heading e.g. ========; note: allow spaces to e.g. = = = =
      next if line =~ /^[ -]+$/         ## skip "decorative"  line e.g. --- or - - - -

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
          ## todo/fix:  strip/remove season if present first - why? why not?
          clubs = []
          headings <<  [ heading, clubs ]
        end
      else
        ##  assume club name

        if clubs.nil?
          puts "** !!! ERROR !!! heading missing / expected; cannot add club; sorry - add heading"
          exit 1
        end

        ## note if line starts with pipe (just delete for now)
        ##   in future bundle together names!!!!
        if line.start_with?( '|' )
           line = line.sub( '|', '' )
           names = parse_names( line )

           club = clubs[-1]  ## get last entry
           if club.nil?
             puts "** !!! ERROR !!! missing required main club line for additional optional name line starting with pipe (|)"
             exit 1
           end
        else
           ## check if starts with number e.g.   1   Liverpool
           line = line.sub( /^[0-9]{1,2}[ ]+/, '' )   if line =~ /^[0-9]{1,2}[ ]+/

           values = line.split( '@' )   ## allow (optinal) geos as 2nd part in line for now
           names = parse_names( values[0] )

           club = { names: [],
                    geos:  []  }
           clubs << club

           if values[1]   ## check for geos; note: for now assume single geo value (no further parsing/splitting)
              club[:geos] <<  values[1].strip
           end
        end

        ## note: add one-by-one to preserve array reference
        names.each {|name| club[:names] << name }
      end
    end
    headings
  end # method parse


  def self.parse_names( line )
    ## check for multiple clubs entries / names
    values = line.split( '|' )
    values = values.map {|value| value.strip }
    values
  end

end # class ClubLintReader



class ConfClubLintReader   ### todo/check: rename to ??? - find a better name? why? why not?

  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end

  def self.parse( txt )
    headings = []
    clubs   = nil   ## current clubs array   ## note: same as headings[-1][1]

    txt.each_line do |line|
      line = line.strip

      next  if line.empty?
      break if line == '__END__'

      next if line.start_with?( '#' )   ## skip comments too

      ## strip inline (until end-of-line) comments too
      ##  e.g  ţ  t  ## U+0163
      ##   =>  ţ  t
      line = line.sub( /#.*/, '' ).strip


      next if line =~ /^[ =]+$/          ## skip "decorative" only heading e.g. ========; note: allow spaces to e.g. = = = =
      next if line =~ /^[ -]+$/         ## skip "decorative"  line e.g. --- or - - - -

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
          ## todo/fix:  strip/remove season if present first - why? why not?
          clubs = []
          headings <<  [ heading, clubs ]
        end
      else
        ##  assume club name

        if clubs.nil?
          puts "** !!! ERROR !!! heading missing / expected; cannot add club; sorry - add heading"
          exit 1
        end

        scan = StringScanner.new( line )

        if scan.check( /\d{1,2}[ ]+/ )    ## entry with standaning starts with ranking e.g. 1,2,3, etc.
            puts "  table entry >#{line}<"
            rank = scan.scan( /\d{1,2}[ ]+/ ).strip   # note: strip trailing spaces

            ## note: uses look ahead scan until we hit at least two spaces
            ##  or the end of string  (standing records for now optional)
            name = scan.scan_until( /(?=\s{2})|$/ )
            if scan.eos?
              standing = nil
            else
              standing = scan.rest.strip   # note: strip leading and trailing spaces
            end
            puts "   rank: >#{rank}<, name: >#{name}<, standing: >#{standing}<"

            clubs << { rank:     rank,
                       name:     name,
                       standing: standing
                     }
         else
            ## assume club is full line
            clubs << { name: line }
         end
      end
    end
    headings
  end # method parse

end # class ConfClubLintReader




def find_club( name, country )   ## todo/fix: add international or league flag?
  club = nil
  m = CLUBS.match_by( name: name, country: country )

  if m.nil?
    ## (re)try with second country - quick hacks for known leagues
    ##  todo/fix: add league flag to activate!!!
    m = CLUBS.match_by( name: name, country: COUNTRIES['wal'])  if country.key == 'eng'
    m = CLUBS.match_by( name: name, country: COUNTRIES['nir'])  if country.key == 'ie'
    m = CLUBS.match_by( name: name, country: COUNTRIES['mc'])   if country.key == 'fr'
    m = CLUBS.match_by( name: name, country: COUNTRIES['li'])   if country.key == 'ch'
    m = CLUBS.match_by( name: name, country: COUNTRIES['ca'])   if country.key == 'us'
  end

  if m.nil?
    ## puts "** !!! WARN !!! no match for club >#{name}<"
  elsif m.size > 1
    puts "** !!! ERROR !!! too many matches (#{m.size}) for club >#{name}<:"
    pp m
    exit 1
  else   # bingo; match - assume size == 1
    club = m[0]
  end

  club
end
