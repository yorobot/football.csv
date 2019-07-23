# encoding: utf-8


require 'csvreader'

def read_csv( path )
  CsvHash.read( path, :header_converters => :symbol )
end


recs = read_csv( './clubs/clubs.txt' )
pp recs
pp recs.size

rec = recs[0]
pp rec[:rank]
pp rec[:name]
pp rec[:country]


###
# check for matching club names

require 'sportdb/config'

SportDb::Import.config.clubs_dir = '../../openfootball/clubs'


recs[0..10].each do |rec|
  pp rec

  name = rec[:name]
  pp name
  clubs = SportDb::Import.config.team_mappings[ name ]
  pp clubs
  if clubs
  else
    puts "** !! ERROR !! no matching club found >#{name}<, #{rec[:country]}"
  end
end

pp SportDb::Import.config.team_mappings.class.name
