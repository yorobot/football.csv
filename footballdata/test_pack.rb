require_relative 'boot'


path = "../../../footballcsv/major-league-soccer"
pack = CsvPackage.new( path )
pp pack.find_entries_by_season    ## change to pack.entries_by_season
                                  ##    or     datafiles_by_season

mls_path = "#{path}/1996/1-mls.csv"
m = CsvMatchReader.read( mls_path )
pp m[0]
pp m[-1]



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
