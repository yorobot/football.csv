require_relative 'table'


basename = 'ar'       # conmebol, ar, ...

tables = WikiTableReader.read( "dl/#{basename}.txt" )
pp tables

buf = String.new
tables.each do |table|
  buf << table[:text]
  buf << "\n\n"

  ## todo/fix:  return array of records [names, city]
  ##  why? let's us mark missing clubs inline !!!!!!
  ##   use !! or something - why? why not?
  buf << convert( table[:rows] )
end

puts buf

File.open( "#{basename}.clubs.txt", 'w:utf-8' ) do |f|
  f.write buf
end
