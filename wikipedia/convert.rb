require 'wikiscript'

require 'sportdb/clubs'   ## used for Club.strip_wiki


def convert_club( value )
  link, title = Wikiscript.parse_link( value )
  if link
    buf = String.new
    ## note: (pre)process wiki link e.g.
    ##   FC Wacker Innsbruck (2012) => FC Wacker Innsbruck
    ##   Willem II (football club)  => Willem II   etc
    buf << SportDb::Import::Club.strip_wiki( link )            
    buf << " | #{title}" if title
    ## todo use WikiLink struct!!!! - why? why not?
    buf
  else
    ## puts "** !!! ERROR !!! - wiki link expected in club cell:"
    ## pp value
    ## exit 1
    puts "** !!! WARN !!! - wiki link expected in club cell:"
    pp value

    value
  end
end

def convert_wiki_club( value )
  link, title = Wikiscript.parse_link( value )
  if link
    link
  else
    ## puts "** !!! ERROR !!! - wiki link expected in club cell:"
    ## pp value
    ## exit 1
    puts "** !!! WARN !!! - wiki link expected in club cell:"
    pp value

    value
  end
end


def convert_city( value )
  ## replace ALL wiki links with title (or link)
  ##  e.g. [[Santiago]] ([[La Florida, Chile|La Florida]])
  ##   =>    Santiago (La Florida)
  value = Wikiscript.unlink( value )
  value
end




def find_header_index( headers_by_index, *candidates )
   index = nil
   ## pp candidates
   candidates.each do |candidate|
     index = headers_by_index[ candidate.downcase ]  ## note: normalize name
     break  if index
   end
   index   ## return nil if not found
end

def convert_club_table( rows )
   out = []

   headers = rows[0]
   data    = rows[1..-1]

   ### check headers if the match know club table columns
   headers_by_index = {}
   headers.each_with_index do |col,i|
     headers_by_index[col.downcase] = i     ## note: normalize name
   end
   pp headers_by_index

   club_index = find_header_index( headers_by_index, 'Club',
                                                     'Club Name',
                                                     'Team' )
   city_index = find_header_index( headers_by_index, 'City',
                                                     'City/State',
                                                     'City (Commune)',
                                                     'Location',
                                                     'Governorate,  City',
                                                     'Stadium Location',  # for us clubs/teams or use 'Region' ??
                                                     'Home City',
                                                     'Home Town' )


   if club_index.nil?
     puts "** !!! ERROR !!! - cannot find club column/index in table (header row):"
     pp headers
     pp data
     exit 1
   end

   if city_index.nil?
     puts "** !!! ERROR !!! - cannot find city/locaction column/index in table (header row):"
     pp headers
     pp data
     exit 1
   end


   data.each do |row|
     next        if row.empty?   ## skip empty line

     ## pp row
     club = row[ club_index ]
     city = row[ city_index ]

     city = ""    if city.nil?

     if club.nil? || city.nil?
       puts "** !!! ERORR !!! - nil value not allowed/expected for now; sorry"
       pp row
       pp data
       exit 1
     end

     club = convert_club( club )
     city = convert_city( city )

     out << [club, city]
   end
   out
end



def convert_club_table_wiki( rows )
  ## assume club, city, ...
   out = []  ##  note: returns array of page link names (NOT an array of rows)

   headers = rows[0]
   ### check headers if the match know club table columns
   headers_by_index = {}
   headers.each_with_index do |col,i|
     headers_by_index[i] = col.downcase    ## note: normalize name
   end

   club_index = find_header_index( headers_by_index, 'Club',
                                                     'Club Name',
                                                     'Team' )

   if club_index.nil?
     puts "** !!! ERROR !!! - cannot find club column/index in table (header row):"
     pp headers
     exit 1
   end


   data    = rows[1..-1]
   data.each do |row|
     ## pp row
     club = convert_wiki_club( row[ club_index ] )
     out << club
   end
   out
end
