require_relative 'convert'


basename = 'at'       # conmebol, ar, at, ...

page = Wikiscript.read( "dl/#{basename}.txt" )
pp page.parse


buf = String.new
page.each do |node|
  if node[0] == :h2
    buf << "= #{node[1]} ="   ## note: convert h2 to h1
    buf << "\n\n"
  elsif node[0] == :table
    data = convert_club_table_wiki( node[1] )
    data.each do |club|
      buf << club
      buf << "\n"
    end
    buf << "\n\n"
  else
    puts "** !!! ERROR !!! unsupported page element type:"
    pp node
    exit 1
  end
end


puts buf

File.open( "o/#{basename}.wiki.txt", 'w:utf-8' ) do |f|
  f.write buf
end
