# encoding: utf-8



#####
# todo:  rename importer to import  (use sportdb-import) for (new) gem name !!!
#


require_relative 'lib/read'



seasons_txt = find_seasons_in_txt( './dl/at-austria/AUT.csv' )
pp seasons_txt
