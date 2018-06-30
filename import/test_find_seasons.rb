# encoding: utf-8



#####
# todo:  rename importer to import  (use sportdb-import) for (new) gem name !!!
#


require 'pp'
require 'csv'
require 'date'

###
# our own code
require_relative 'read_txt'


find_seasons_in_txt( './dl/at-austria/AT.csv' )
