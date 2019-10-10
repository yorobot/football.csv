require_relative 'check_clubs'



###
## todo/fix: use new club structure/hash; still coded for "old" names-only list


def check_clubs( names, country )   ## todo/fix: add international or league flag?
  missing_clubs = []

  names.each do |name|

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



def check_clubs_by_countries( countries )
  missing_clubs = []

  countries.each do |rec|
    heading     = rec[0]
    club_names  = rec[1]

    if heading =~ %r{ \(([a-z]{2,3})\) }x
      country = COUNTRIES[ $1 ]
      if country.nil?
        puts "!!! error [club reader] - unknown country code >#{$1}< in >#{heading}< - sorry - add country to config to fix"
        exit 1
      end

      missing = check_clubs( club_names, country )
      missing_clubs << [heading, missing]
    else
      puts "!!! error [club reader] - unknown country format  >#{heading}< - sorry - two or three-letter lowercase letter eg (ab) or (abc) expected"
      exit 1
    end
  end
  missing_clubs
end



def check_clubs_by_leagues( leagues )
  missing_clubs = []

  leagues.each do |rec|
    heading     = rec[0]
    club_names  = rec[1]

    m = LEAGUES.match( heading )
    if m.nil?
      puts "!!! error [club reader] - unknown league  >#{heading}< - sorry - add league to config to fix"
      exit 1
    else   ## todo/fix: check for more than one match error too!!!
      league = m[0]
    end

    missing = check_clubs( club_names, league.country )
    missing_clubs << [heading, missing]
  end
  missing_clubs
end
