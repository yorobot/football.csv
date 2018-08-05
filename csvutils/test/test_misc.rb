# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_misc.rb


require 'helper'

class TestMiscellaneous < MiniTest::Test

  def test_test_eng
    path = "#{CsvUtils.test_data_dir}/eng-england/2017-18/E0.csv"

    CsvUtils.test( path )
    assert true
  end

  def test_test_de
    path = "#{CsvUtils.test_data_dir}/de-deutschland/bundesliga.csv"

    CsvUtils.test( path, sep: ';' )
    assert true
  end

  def test_test_at
    path = "#{CsvUtils.test_data_dir}/at-austria/AUT.csv"

    CsvUtils.test( path )
    assert true
  end

end # class TestMiscellaneous
