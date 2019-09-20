require 'wikiscript'



def convert_club( value )
  link, title = Wikiscript.parse_link( value )
  if link
    buf = String.new
    buf << link
    buf << " | #{title}" if title
    ## todo use WikiLink struct!!!! - why? why not?
    buf
  else
    puts "** !!! ERROR !!! - wiki link expected in club cell:"
    pp value
    exit 1
  end
end

def convert_wiki_club( value )
  link, title = Wikiscript.parse_link( value )
  if link
    link
  else
    puts "** !!! ERROR !!! - wiki link expected in club cell:"
    pp value
    exit 1
  end
end

def convert_city( value )
  ## replace ALL wiki links with title (or link)
  ##  e.g. [[Santiago]] ([[La Florida, Chile|La Florida]])
  ##   =>    Santiago (La Florida)
  value = Wikiscript.unlink( value )
  value
end



def convert_club_table( rows )
  ## assume club, city, ...
   out = []

   headers = rows[0]
   data    = rows[1..-1]
   data.each do |row|
     ## pp row
     club = convert_club( row[0] )
     city = convert_city( row[1] )
     out << [club, city]
   end
   out
end


def convert_club_table_wiki( rows )
  ## assume club, city, ...
   out = []  ##  note: returns array of page link names (NOT an array of rows)

   headers = rows[0]
   data    = rows[1..-1]
   data.each do |row|
     ## pp row
     club = convert_wiki_club( row[0] )
     out << club
   end
   out
end
