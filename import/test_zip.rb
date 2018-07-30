# encoding: utf-8


require_relative 'lib/import'


## map country_key + level to league key
LEAGUE_KEYS =
{
  'de' => {
    1 => 'de',    ## use de.1 - why? why not?
    2 => 'de.2'
  },
  'eng' => {
    1 => 'en',     ## use eng / eng.1 - why? why not?
    2 => 'en.2'
  }
}


## loop over datafiles in zip
path = "./tmp/de-deutschland.zip"

zipfile = Zip::File.open( path )

## note: returns an array of Zip::Entry
query = "**/*.csv"
zipentries = zipfile.glob( query )
pp zipentries



database = ':memory:'
## database = './eng.db'
## database = './top.db'


SportDb.connect( adapter:  'sqlite3',
                 database: database )

## build schema
SportDb.create_all


country_key = 'de'    ## todo: get country key from package / repo name

zipentries.each do |zipentry|

  text = zipentry.get_input_stream().read()
  text = text.force_encoding( Encoding::UTF_8 )

  ## pp text

  matches = CsvMatchReader.parse( text )
  ## pp matches

  basename = File.basename( zipentry.name, '.csv' )
  dirname  = File.dirname( zipentry.name )

  pp basename  ## e.g. "1-bundesliga"
  pp dirname   ## e.g. "de-deutschland-master/1960s/1963-64"

  level = LevelUtils.level( basename )
  pp level

  season = File.basename( dirname )   ## assume last directory/folder is season
  pp season


  season_key  = season
  league_key  = LEAGUE_KEYS[ country_key][ level ]

  pp country_key
  pp season_key
  pp league_key

  season  = SportDb::Importer::Season.find( season_key )
  league  = SportDb::Importer::League.find( league_key )
  country = SportDb::Importer::Country.find( country_key )

  update_matches_txt( matches,
                        season:  season,
                        league:  league,
                        country: country )
end

zipfile.close()
