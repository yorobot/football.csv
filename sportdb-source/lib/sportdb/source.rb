# encoding: utf-8



## 3rd party gems
require 'fetcher'

require 'sportdb/text'


###
# our own code
require 'sportdb/source/version' # let version always go first

require 'sportdb/source/footballdata/config_i'
require 'sportdb/source/footballdata/config_ii'
require 'sportdb/source/footballdata/fetch'
require 'sportdb/source/footballdata/convert'



puts SportDb::Source.banner   # say hello
