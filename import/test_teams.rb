# encoding: utf-8

#####
# todo:  rename importer to import  (use sportdb-import) for (new) gem name !!!
#


require_relative 'lib/read'


pp SportDb::Import::TEAMS_DE
pp SportDb::Import::TEAMS_TR

puts "-----------"

pp SportDb::Import::TEAMS

pp SportDb::Import::PRINT_TEAMS    ## pretty print team names (reverse hash lookup)
