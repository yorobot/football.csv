require 'pp'


class WikiTableReader

  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end


  def self.parse_table( txt )   ## only allow single table
    tables = parse( txt )

    if tables.size == 0
      puts "** !!! ERROR !!! no table found in text"
      exit 1
    elsif tables.size > 1
      puts "** !!! ERROR !!! too many tables (#{tables.size}) found in text; only one expected/allowed; sorry"
      exit 1
    else
      tables[0]    ## pass-along first table; everything ok
    end
  end

  def self.parse( txt )
    tables = []     ## todo/check: allow multiple tables? why? why not?

    rows   = nil   ## note: assume first row is the headers row!!
    row    = nil   ## current row  ## note: same as rows[-1]

    inside_table = false

    txt.each_line do |line|
      line = line.strip

      break if line == '__END__'

      ## note:  allow/add comments
      ##   note: CANNOT allow inline (end-of-line) comments
      ##     would strip/break css colors eg.  bgcolor=#ffff44
      next if line.start_with?( '#' )   ## skip comments too
      next if line.empty?               ## skip empty lines for now


      ## note:  for the table format
      ##  see https://en.wikipedia.org/wiki/Help:Basic_table_markup

      if line.start_with?( '{|' )     ## start table
        inside_table = true
        rows = []
      elsif inside_table && line.start_with?( '|}' )  ## end table
        tables << rows
        rows   = nil
        row    = nil
        inside_table = false
      elsif inside_table && line.start_with?( '|-' )  ## row divider
         row = []
         rows << row
      elsif inside_table && line.start_with?( '!' )    ## header column
         values = line.sub( '!', '' ).strip.split( '!!' )
         ## note: |-  row divider is optional before header columns
         if rows.empty?
           row = []
           rows << row
         end
         ## add each value one-by-one for now (to keep (same) row reference)
         ##   note: also strip leading (optional) attributes
         values.each do |value|
           row <<  strip_emphases( strip_attributes( value.strip ))
         end
      elsif inside_table && line.start_with?( '|' )   ## table data
         values = line.sub( '|', '' ).strip.split( '||' )
         ## add each value one-by-one for now (to keep (same) row reference)
         values.each do |value|
           row <<  strip_emphases( strip_attributes( value.strip ))
         end
      elsif inside_table
        puts "!! ERROR !! unknown line type inside table:"
        puts line
        exit 1
      else
        puts "!! ERROR !! unknown line type outside (before or after) table:"
        puts line
        exit 1
      end
    end
    tables
  end # method parse

  ####
  # helper
  def self.strip_attributes( value )
    if value =~ /^[a-z]+=/                      ## if starts with 'attribute='
      value = value.sub( /[^|]+\|[ ]*/ , '' )   ## strip everything incl. pipe (|) and trailing spaces
    else
      value   ## return as-is (pass-through)
    end
  end

  def self.strip_emphases( value )   ## strip bold or emphasis; note: emphases plural of emphasis
    value = value.gsub( /'{2,}/, '' ).strip   ## remove two or more quotes e.g. '' or ''' etc.
    value
  end

end # class WikiTableReader
