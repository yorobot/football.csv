
require 'sportdb/config'


## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"
SportDb::Import.config.leagues_dir = "../../../openfootball/leagues"



LEAGUES   = SportDb::Import.config.leagues
CLUBS     = SportDb::Import.config.clubs
COUNTRIES = SportDb::Import.config.countries




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
