require 'pp'


class WikiTableReader

  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end

  def self.parse( txt )
    rows = nil   ## note: assume first row is the headers row!!
    row  = nil   ## current row  ## note: same as rows[-1]

    inside_table = false


    txt.each_line do |line|
      line = line.strip

      next  if line.empty?
      break if line == '__END__'

      next if line.start_with?( '#' )   ## skip comments too

      ## strip inline (until end-of-line) comments too
      ##  e.g  ţ  t  ## U+0163
      ##   =>  ţ  t
      line = line.sub( /#.*/, '' ).strip


      next if line =~ /^[ =]+$/          ## skip "decorative" only heading e.g. ========; note: allow spaces to e.g. = = = =
      next if line =~ /^[ -]+$/         ## skip "decorative"  line e.g. --- or - - - -


      if line.start_with?( '{|' )     ## start table
        ## todo/fix: reset rows / headers
        inside_table = true
        rows = []
      elsif inside_table && line.start_with?( '|}' )  ## end table
        inside_table = false
      elsif inside_table && line.start_with?( '|-' )  ## row divider
         row = []
         rows << row
      elsif inside_table && line.start_with?( '!' )    ## header column
         value = line.sub( '!', '' ).strip   ## assume single column value/name for now
         row << value
      elsif inside_table && line.start_with?( '|' )   ## table data
         values = line.sub( '|', '' ).strip.split( '||' )
         ## add each value one-by-one for now (to keep (same) row reference)
         values.each do |value|
           row << value.strip
         end
      else
        puts "!! WARN !! skipping unknown line type: "
        puts line
      end
    end
    rows
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


def convert( rows )
  ## assume club, city
   headers = rows[0]
   data    = rows[1..-1]
   data.each do |row|
     ## pp row
     row.each do |value|
       if (m = WIKI_LINK_PATTERN.match( value ))
         link  = m[:link]
         title = m[:title]

         buf = String.new
         buf << link.strip
         buf << " | #{title.strip}" if title
         ## todo use WikiLink struct!!!! - why? why not?
         puts buf
       else
         puts "** !!! ERROR !!! - wiki link expected:"
         pp row
         exit 1
       end
     end
   end
end

rows = WikiTableReader.read( 'ar.txt' )
pp rows
convert( rows )
