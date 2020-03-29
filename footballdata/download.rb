# encoding: utf-8

## note: use the local version of sportdb-source gem
$LOAD_PATH.unshift( File.expand_path( '../sportdb-source-footballdata/lib') )

require 'sportdb/match/formats'        ## working around - why needed? activerecord auto-loading?
require 'sportdb/source/footballdata'



Footballdata.download     ## saves all datasets to ./dl

puts "bye"
