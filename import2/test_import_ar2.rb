# encoding: utf-8

require 'sportdb/text'

SportDb::Import.config.clubs_dir = '../../openfootball/clubs'


## todo:  sort dirs before matching ??  now we get:
=begin
[["2012/13", ["2012-13/ar.1.csv"]],
 ["2013/14", ["2013-14/ar.1.csv"]],
 ["2016/17", ["2016-17/ar.1.csv"]],
 ["2017/18", ["2017-18/ar.1.csv"]],
 ["2018/19", ["2018-19/ar.1.csv"]],
 ["2014", ["2014/ar.1.csv"]],
 ["2015", ["2015/ar.1.csv"]],
 ["2016", ["2016/ar.1.csv"]]]
=end


pack = CsvPackage.new( './o/argentina' )
pp pack.find_entries_by_season
pp pack.find_entries_by_season_n_division

report = CsvTeamsReport.new( pack )
## txt = report.build
## puts txt
report.save( './o/argentina/TEAMS.md' )
