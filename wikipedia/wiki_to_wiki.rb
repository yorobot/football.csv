require_relative 'table'


basename = 'conmebol'       # conmebol, ar, ...

tables = WikiTableReader.read( "dl/#{basename}.txt" )
pp tables

buf = String.new
tables.each do |table|
  buf << table[:text]
  buf << "\n\n"

  ## todo/fix:  return array of records
  ##  why? let's us mark missing clubs inline !!!!!!
  ##   use !! or something - why? why not?
  buf << convert_wiki( table[:rows] )
end

puts buf

File.open( "#{basename}.wiki.txt", 'w:utf-8' ) do |f|
  f.write buf
end
