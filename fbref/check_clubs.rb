## check clubs

require 'sportdb/config'

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"
SportDb::Import.config.leagues_dir = '../../../openfootball/leagues'


LEAGUES   = SportDb::Import.config.leagues
CLUBS     = SportDb::Import.config.clubs
COUNTRIES = SportDb::Import.config.countries




def read_clubs( path )
  clubs = Hash.new( 0 )    ## track club names & match count

  recs = CsvHash.read( path, :header_converters => :symbol )
  pp recs.size
  pp recs[0]

  recs.each do |rec|
    team1 = rec[:home]
    team2 = rec[:away]

    next if team1.empty? && team2.empty?   ## skip empty records / lines

    ## if international - normalize country code ( move two-or-three letter to back)
    ##  e.g. at, be, eng (!), etc.
    ## switch country code from begin to end e.g.
    ##    eng Liverpool => Liverpool eng
    if team2 =~ /^([a-z]{2,3})[ ]+(.+)$/
      team2 = "#{$2} #{$1}"
    end


    names = [ team1, team2 ]
    names.each do |name|
      clubs[ name ] += 1
    end
  end

  pp clubs

  sorted_clubs = clubs.to_a.sort do |l,r|
    ## sort by 1) counter 2) name a-z
    res = r[1] <=> l[1]
    res = l[0] <=> r[0]     if res == 0
    res
  end

  sorted_clubs
end


def dump_clubs( path, default_country_key=nil )
  sorted_clubs = read_clubs( path )

  puts "sorted clubs (#{sorted_clubs.size}):"
  sorted_clubs.each do |rec|

    name_long  = rec[0]
    count      = rec[1]

    if name_long =~ /^(.+)[ ]+([a-z]{2,3})$/
      name        = $1
      country_key = $2
      country     = COUNTRIES[ country_key ]
      national    = false
    else
      name        = name_long
      country_key = default_country_key  # e.g. 'at', 'eng'
      country     = COUNTRIES[ country_key ]
      national    = true
    end

    ## puts "name=>#{name}<"
    ## pp rec

    m = CLUBS.match_by( name: name, country: country )

    if m.nil? && national
      ## (re)try with second country - quick hacks for known leagues
      m = CLUBS.match_by( name: name, country: COUNTRIES['wal'])  if country.key == 'eng'
      m = CLUBS.match_by( name: name, country: COUNTRIES['mc'])   if country.key == 'fr'
      m = CLUBS.match_by( name: name, country: COUNTRIES['li'])   if country.key == 'ch'
      m = CLUBS.match_by( name: name, country: COUNTRIES['ca'])   if country.key == 'us'
      m = CLUBS.match_by( name: name, country: COUNTRIES['nz'])   if country.key == 'au'
    end

    if m.nil?
      print "!!    "
       ## puts "** !!! WARN !!! no match for club <#{name_long}>:"
       ## pp rec
    elsif m.size > 1
      ## more than one match (ambigious)!!!
      print "!! (#{m.size})"
    else
      print "      "
    end

    puts "   #{'%3s'%count} #{name_long}"
  end
end


## dump_clubs( "2019-20/eng.1.csv", :eng )
dump_clubs( "2019-20/el.csv" )
