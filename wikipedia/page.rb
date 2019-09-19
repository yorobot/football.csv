require_relative   'table'


class WikiPageReader

  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end


  def self.parse( txt )
    page = []   ## page structure

    inside_table = false
    table_txt    = nil

    txt.each_line do |line|
      line = line.strip

      break if line == '__END__'

      ## note:  allow/add comments
      ##   note: CANNOT allow inline (end-of-line) comments
      ##     would strip/break css colors eg.  bgcolor=#ffff44
      next if line.start_with?( '#' )   ## skip comments too
      next if line.empty?               ## skip empty lines for now

      ## note: like in wikimedia markup (and markdown) all optional trailing ==== too
      ##  todo/check:  allow ===  Text  =-=-=-=-=-=   too - why? why not?
      if line =~ /^(={1,})       ## leading ======
                  ([^=]+?)       ##  text   (note: for now no "inline" = allowed)
                  =*             ## (optional) trailing ====
                  $/x
        heading_marker = $1
        heading_level  = $1.length   ## count number of = for heading level
        heading        = $2.strip

        puts "heading #{heading_level} >#{heading}<"
        page << [:"h#{heading_level}", heading]
      elsif line.start_with?( '{|' )     ## start table
        inside_table = true
        table_txt = String.new   ## collect table source text
        table_txt << line << "\n"    ## note: do NOT forget to add back newline!!
      elsif inside_table && line.start_with?( '|}' )  ## end table
        table_txt << line << "\n"
        table = WikiTableReader.parse_table( table_txt )
        page << [:table, table]
        ## reset table variables
        inside_table = false
        table_txt    = nil
      elsif inside_table
         table_txt << line << "\n"
      else
        puts "** !!! ERROR !!! unknown line type in wiki page:"
        pp line
        exit 1
      end
    end
    page
  end # method parse
end # class WikiPageReader
