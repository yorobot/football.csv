# encoding: utf-8

#####
# todo:  rename importer to import  (use sportdb-import) for (new) gem name !!!
#


require_relative 'lib/read'


pp SportDb::Import.config.team_mappings

puts "-----------"

pp SportDb::Import.config.teams
