# encoding: utf-8



## check/use class or module ???


class CsvUtils

  def self.cut( in_path, out_path, *columns, col_sep: ',' )

    puts "cvscut in: >#{in_path}<  out: >#{out_path}<"

    ##  ["Date", "HomeTeam", "AwayTeam", "FTHG", "FTAG", "HTHG", "HTAG"]
    puts "columns:"
    pp columns

    text = File.open( in_path, 'r:utf-8' ).read   ## note: make sure to use (assume) utf-8

    csv_options = { headers: true,
                    col_sep: col_sep }
                ###  external_encoding: 'utf-8' }   ## note: always use (assume) utf8 for now

    table = CSV.parse( text, csv_options )


    ## for convenience - make sure parent folders/directories exist
    FileUtils.mkdir_p( File.dirname( out_path ))  unless Dir.exists?( File.dirname( out_path ))

    ## use wb mode - why? why not?
    ##   assumes same encoding as input?
    ##   fix/todo: better (always) use utf8!!!!
    ## CSV.open( out_path, 'wb' ) do |out|

    ## use just "regular" File for output - why? why not?
    ##    downside will not encode comma (for now) if present ("Beethoven, van")
    ##      all values will be unquoted etc. - keep it simple?

    CSV.open( out_path, 'w:utf-8' ) do |out|
      out << columns   ## fir row add headers/columns
      table.each do |row|
        values = columns.map { |col| row[col].strip }  ## find data for column
        out << values
      end
    end

    puts 'Done.'
  end  ## method self.cut

end # class CsvUtils
