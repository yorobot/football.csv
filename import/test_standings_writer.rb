# encoding: utf-8


require_relative 'lib/read'



pack = CsvPackage.new( 'be-belgium', path: './o' )

standings = CsvStandingsWriter.new( pack )
standings.write
standings.write( path: './o/be-belgium-xxx' )   ## try a different root path
