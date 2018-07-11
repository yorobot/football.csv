# encoding: utf-8



require_relative 'lib/read'


es = CsvPackage.new( 'es-espana', path: './o' )

es_pyramid = CsvPyramidReport.new( es )
puts es_pyramid.build_summary

es_pyramid.save( './o/es_pyramid.txt' )


sco = CsvPackage.new( 'sco-scotland', path: './o' )

sco_pyramid = CsvPyramidReport.new( sco )
puts sco_pyramid.build_summary

sco_pyramid.save( './o/sco_pyramid.txt' )


fr = CsvPackage.new( 'fr-france', path: './o' )

fr_pyramid = CsvPyramidReport.new( fr )
puts fr_pyramid.build_summary

fr_pyramid.save( './o/fr_pyramid.txt' )
