# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_fetch.rb


require 'helper'

class TestFetch < MiniTest::Test

  def test_sources
    pp FOOTBALLDATA_SOURCES

    pp FOOTBALLDATA_SOURCES_II
  end

  def test_fetch_at
    Footballdata.fetch( :at, out_dir: './dl'  )
  end

  def test_fetch_eng
    Footballdata.fetch( :eng, out_dir: './dl')
  end

  def test_fetch_all
     Footballdata.fetch( out_dir: './dl' )
  end

end # class TestFetch
