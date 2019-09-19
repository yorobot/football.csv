require 'minitest/autorun'


require_relative   'page'


class TestPage < MiniTest::Test

  def test_basic
    page = WikiPageReader.parse( <<TXT )
=Heading 1==
==Heading 2==
===Heading 3===

{|
|-
! header1
! header2
! header3
|-
| row1cell1
| row1cell2
| row1cell3
|-
| row2cell1
| row2cell2
| row2cell3
|}
TXT

    pp page

    assert_equal 4, page.size
    assert_equal [:h1, 'Heading 1'],  page[0]
    assert_equal [:h2, 'Heading 2'],  page[1]
    assert_equal [:h3, 'Heading 3'],  page[2]
    assert_equal [:table, [['header1', 'header2', 'header3'],
                           ['row1cell1', 'row1cell2', 'row1cell3'],
                           ['row2cell1', 'row2cell2', 'row2cell3']]],  page[3]
  end

end # class TestPage
