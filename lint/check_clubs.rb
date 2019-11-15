
require 'sportdb/config'


## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"
SportDb::Import.config.leagues_dir = "../../../openfootball/leagues"



LEAGUES   = SportDb::Import.config.leagues
CLUBS     = SportDb::Import.config.clubs
COUNTRIES = SportDb::Import.config.countries



def check_clubs_by_countries( nodes )
  count = 0   ## track/count number of missing clubs
  nodes.each do |node|
    heading = node[0]

    country = COUNTRIES[ heading ]
    pp country

    if country.nil?
      puts "** !!! ERROR !!! [club lint reader] - unknown country >#{heading}< in heading - sorry - add country to config to fix"
      exit 1
    end

    recs = node[1]
    count += check_clubs( recs, country )
  end
  count
end

def check_clubs_by_leagues( nodes )
  count = 0   ## track/count number of missing clubs
  nodes.each do |node|
    heading = node[0]

    m = LEAGUES.match( heading )
    if m.nil?
      puts "** !!! ERROR [club lint reader] - unknown league  >#{heading}< - sorry - add league to config to fix"
      exit 1
    else   ## todo/fix: check for more than one match error too!!!
      league = m[0]
    end

    recs = node[1]
    count += check_clubs( recs, league.country )
  end
  count
end



def check_clubs( recs, country )
    count = 0   ## track/count number of missing clubs
    ## add errors = [] - why? why not?   pass in heading (for error msg)

    recs.each do |rec|
      names = rec[:names]

      ## check for missing club or missing (alternate) name
      ## check if all matches are the same club too!!!!
      clubs   = []
      missing = []
      names.each do |name|
        ## note: use match to allow "ambigous" matches (more than one club too!!!!)
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

        if m
          clubs += m
        else
          missing << name
          count += 1
        end
      end

      ## check if found
      if clubs.empty?
        puts "!! club missing / not found any name (#{names.size}):"
        puts "    #{names.join(' | ')}"
      else
        ## check if clubs are the same (MUST be the same)
        uniq_clubs = clubs.uniq
        if uniq_clubs.size > 1
          puts "!! club names ambigious - matching #{uniq_clubs.size} clubs:"
          puts "    #{names.join(' | ')}"
          puts "    #{clubs.inspect}"
        end

        if missing.size > 0
          puts "!! #{missing.size} club (alternate) name(s) missing for >#{clubs[0].name} (#{clubs[0].alt_names.join(' | ')})< :"
          puts "    #{missing.join(' | ')}"
          puts "    #{names.join(' | ')}"
        end

        if missing.empty? && uniq_clubs.size == 1
          puts "OK   >#{names.join(' | ')}< (#{names.size}) matching >#{clubs[0].name}<"
        end
      end
    end
  count
end   # method check_clubs
