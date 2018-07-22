# encoding: utf-8


require 'pp'

## note: add local sportdb/text to load path

$:.unshift( './sportdb-text/lib' )
pp $:

## pp File.read( './sportdb-text/lib/sportdb/text/version.rb' )

require 'sportdb/text'
