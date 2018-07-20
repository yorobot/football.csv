# encoding: utf-8



require 'pp'
require 'csv'
require 'date'



###
# our own code
require 'sportdb/text/version' # let version always go first

require 'sportdb/text/structs/match'
require 'sportdb/text/structs/matchlist'
require 'sportdb/text/structs/standings'
require 'sportdb/text/structs/team'
require 'sportdb/text/structs/team_usage'


require 'sportdb/text/config'

require 'sportdb/text/season_utils'
require 'sportdb/text/level_utils'


require 'sportdb/text/csv/reader'
require 'sportdb/text/csv/converter'
require 'sportdb/text/csv/package'
require 'sportdb/text/csv/standings'
require 'sportdb/text/csv/reports/summary.rb'
require 'sportdb/text/csv/reports/teams.rb'
require 'sportdb/text/csv/reports/pyramid.rb'


require 'sportdb/text/csv/reports/team_city.rb'
require 'sportdb/text/csv/reports/team_mapping.rb'




puts SportDb::Text.banner   # say hello