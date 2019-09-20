require_relative 'convert'


basename = 'at'       # conmebol, ar, at ...

page = Wikiscript::PageReader.read( "dl/#{basename}.txt" )
pp page

buf = String.new
page.each do |el|
  if el[0] == :h2
    buf << "= #{el[1]} ="   ## note: convert h2 to h1
    buf << "\n\n"
  elsif el[0] == :table
    data = convert_club_table( el[1] )
    data.each do |row|
      club = row[0]
      city = row[1]
      buf << "#{'%-50s'%club}   # #{city}"
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

File.open( "#{basename}.clubs.txt", 'w:utf-8' ) do |f|
  f.write buf
end
