require_relative 'page'


##
## todo: fix? - strip spaces from link and title
##   spaces possible? strip in ruby later e.g. use strip - why? why not?

WIKI_LINK_PATTERN = %r{
    \[\[
      (?<link>[^|\]]+)     # everything but pipe (|) or bracket (])
      (?:
        \|
        (?<title>[^\]]+)
      )?                   # optional wiki link title
    \]\]
  }x


def convert_club( value )
  if (m = WIKI_LINK_PATTERN.match( value ))
    link  = m[:link]
    title = m[:title]

    buf = String.new
    buf << link.strip
    buf << " | #{title.strip}" if title
    ## todo use WikiLink struct!!!! - why? why not?
    buf
  else
    puts "** !!! ERROR !!! - wiki link expected in club cell:"
    pp value
    exit 1
  end
end

def convert_wiki_club( value )
  if (m = WIKI_LINK_PATTERN.match( value ))
    link  = m[:link]
    title = m[:title]

    link.strip
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
  value = value.gsub( WIKI_LINK_PATTERN ) do |_|
    link  = $~[:link]
    title = $~[:title]

    if title
      title
    else
      link
    end
  end

  value.strip
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
