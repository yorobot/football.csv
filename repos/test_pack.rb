require_relative 'boot'


path = "../../../footballcsv/major-league-soccer"
pack = CsvPackage.new( path )
pp pack.find_entries_by_season    ## change to pack.entries_by_season
                                  ##    or     datafiles_by_season

mls_path = "#{path}/1996/1-mls.csv"
m = CsvMatchReader.read( mls_path )
pp m[0]
pp m[-1]

m = SportDb::Struct::Matchlist.new( m )
puts "#{m.teams.size} teams:"
pp m.teams

puts "#{m.stages.size} stages:"
pp m.stages


__END__

path = "../../../footballcsv/europe-champions-league"
pack = CsvPackage.new( path )
pp pack.find_entries_by_season    ## change to pack.entries_by_season

champs_path = "#{path}/1955-56/champs.csv"
m = CsvMatchReader.read( champs_path )
pp m[0]
pp m[-1]

champs_path = "#{path}/2015-16/champs.csv"
m = CsvMatchReader.read( champs_path )
pp m[0]
pp m[-1]
