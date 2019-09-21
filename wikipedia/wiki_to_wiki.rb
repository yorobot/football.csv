require_relative 'convert'


basename = 'at'       # conmebol, ar, at, ...

page = Wikiscript.read( "dl/#{basename}.txt" )
elements = page.parse
pp elements

buf = String.new
elements.each do |el|
  if el[0] == :h2
    buf << "= #{el[1]} ="   ## note: convert h2 to h1
    buf << "\n\n"
  elsif el[0] == :table
    data = convert_club_table_wiki( el[1] )
    data.each do |club|
      buf << club
      buf << "\n"
    end
    buf << "\n\n"
  else
    puts "** !!! ERROR !!! unsupported page element type:"
    pp el
    exit 1
  end
end


puts buf

File.open( "#{basename}.wiki.txt", 'w:utf-8' ) do |f|
  f.write buf
end
