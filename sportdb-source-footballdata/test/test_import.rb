# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_import.rb


require 'helper'

class TestImport < MiniTest::Test

  def setup
    ## SportDb::Import.config.clubs_dir = '../../../openfootball/clubs'

    SportDb.connect( adapter:  'sqlite3',
                     database: ':memory:' )

    ## build database schema / tables
    SportDb.create_all
  end


  def test_import_at
    Footballdata.import( :at, dir: './dl'  )
  end

  def test_import_eng
    Footballdata.import( :eng, dir: './dl')
  end

  def test_import_all
     Footballdata.import( dir: './dl' )
  end

end # class TestImport
