require 'sportdb/formats'

##
#  check for tabs (\t) and warn
#  check for unicode spaces (e.g. \u2002) and warn
#  check for unicode minus sign (e.g. \u2212)) and warn
#    todo/fix - add more


class CharLinter

  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    puts "reading >#{path}<..."
    parse( txt )
  end

  def self.fix( path )   ## todo/check: rename to read_fix or update or fixup
    txt_fixed = read( path )
    File.open( path, 'w:utf-8' ) { |f| f.write txt_fixed }
    txt_fixed
  end



  def self.warn_replace( line, lineno, what )
    puts "** !!!WARN!!! line #{lineno}: replacing #{what} in:"
    puts "              >>#{line}"
  end

  def self.parse( txt )
    txt_fixed = String.new
    lineno = 0
    txt.each_line do |line|    # note: line keeps (includes) trailing newline/line feed (\n or \r\n)
      lineno += 1

      line_fixed = line.gsub( "\u{2002}" ) do |_|
        warn_replace( line, lineno, "unicode space (U+2002) >\u{2002}<" )
        " "  ## use regular ascii space
      end
      line_fixed = line_fixed.gsub( "\u{2212}" ) do |_|
        warn_replace( line, lineno, "unicode minus sign (U+2212) >\u{2212}<" )
        "-"  ## use regular ascii minus ("dash")
      end
      line_fixed = line_fixed.gsub( "\t" ) do |_|
        warn_replace( line, lineno, "tab (\\t) >\t<" )
        " "  ## use regular ascii space
      end

      txt_fixed << line_fixed
    end

    txt_fixed
  end
end   # class CharLinter
