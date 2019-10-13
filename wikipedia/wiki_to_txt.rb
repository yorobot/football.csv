require_relative 'convert'


basename = 'ar'       # conmebol, afc, ar, at ...


page = Wikiscript.read( "dl/#{basename}.txt" )
pp page.parse

buf = String.new
page.each do |node|
  if node[0] == :h2
    buf << "= #{node[1]} ="   ## note: convert h2 to h1
    buf << "\n\n"
  elsif node[0] == :h3
    puts "** !!! WARN !!! skipping heading 3 >#{node[1]}<"
    buf << "# h3: #{node[1]}\n\n"
  elsif node[0] == :table
    ## add table heading as comment
    buf << "# table rows: #{node[1].size-1}, "
    buf << "headers: #{node[1][0].size}  ! #{node[1][0].join( ' !! ' )}\n\n"

    data = convert_club_table( node[1] )
    data.each do |row|
      club = row[0]
      city = row[1]
      buf << "#{'%-50s'%club}   # #{city}"
      buf << "\n"
    end
    buf << "\n\n"
  else
    puts "** !!! ERROR !!! unsupported page element type:"
    pp node
    exit 1
  end
end


## puts buf

File.open( "o/#{basename}.clubs.txt", 'w:utf-8' ) do |f|
  f.write buf
end
