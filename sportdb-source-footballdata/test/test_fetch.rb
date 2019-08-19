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

end # class TestFetch
