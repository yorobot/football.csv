require 'pp'


class WikiTableReader

  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end


  def self.parse( txt )
    tables = []

    header = String.new    ## header (intro) text (before table)
    rows   = nil   ## note: assume first row is the headers row!!
    row    = nil   ## current row  ## note: same as rows[-1]

    inside_table = false


    txt.each_line do |line|
      line = line.strip

      break if line == '__END__'

      ## note: strip comments  (and inline end-of-line comments too)
      next if line.start_with?( '#' )   ## skip comments too
      line = line.sub( /#.*/, '' ).strip


      if line.start_with?( '{|' )     ## start table
        ## todo/fix: reset rows / headers
        inside_table = true
        rows = []
      elsif inside_table && line.start_with?( '|}' )  ## end table
        tables << { text: header, rows: rows }
        header = String.new    ## reset table variables
        rows   = nil
        row    = nil
        inside_table = false
      elsif inside_table && line.start_with?( '|-' )  ## row divider
         row = []
         rows << row
      elsif inside_table && line.start_with?( '!' )    ## header column
         values = line.sub( '!', '' ).strip.split( '!!' )
         values.each do |value|
           row << value.strip
         end
      elsif inside_table && line.start_with?( '|' )   ## table data
         values = line.sub( '|', '' ).strip.split( '||' )
         ## add each value one-by-one for now (to keep (same) row reference)
         values.each do |value|
           row << value.strip
         end
      elsif inside_table
        puts "!! ERROR !! unknown line type inside table:"
        puts line
        exit 1
      else
        header << line
        header << "\n"
      end
    end
    tables
  end # method parse
end # class WikiTableReader



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


def convert( rows )
  ## assume club, city, ...
   buf = String.new

   headers = rows[0]
   data    = rows[1..-1]
   data.each do |row|
     ## pp row

     club = convert_club( row[0] )
     city = convert_city( row[1] )
     buf << "#{'%-50s'%club}   # #{city}"
     buf << "\n"
   end
   buf
end


def convert_wiki( rows )
  ## assume club, city, ...
   buf = String.new

   headers = rows[0]
   data    = rows[1..-1]
   data.each do |row|
     ## pp row

     club = convert_wiki_club( row[0] )
     buf << club
     buf << "\n"
   end
   buf
end
