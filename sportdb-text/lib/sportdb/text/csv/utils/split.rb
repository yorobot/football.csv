# encoding: utf-8




class CsvUtils

  def self.split( path, *columns, col_sep: ',', &blk )

    puts "cvssplit in: >#{path}<"

    ##  ["Date", "HomeTeam", "AwayTeam", "FTHG", "FTAG", "HTHG", "HTAG"]
    puts "columns:"
    pp columns

    text = File.open( path, 'r:utf-8' ).read   ## note: make sure to use (assume) utf-8

    ## note: do NOT use headers
    ##   for easy sorting use "plain" array of array for records
    csv_options = { col_sep: col_sep }

    data = CSV.parse( text, csv_options )
    headers = data.shift   ## remove top array item (that is, row with headers)

    header_mapping = {}
    headers.each_with_index  { | header,i | header_mapping[header]=i }
    pp header_mapping

    ## map columns to array indices e.g. ['Season', 'Div'] => [1,2]
    column_indices = columns.map { |col| header_mapping[col] }
    pp column_indices


    ###################################################
    ## note: sort data by columns (before split)
    data = data.sort do |row1,row2|
       res = 0
       column_indices.each do |col|
         res = row1[col] <=> row2[col]    if res == 0
       end
       res
    end

    ## fix/todo: change to - check next row!!!!
    ##   why? no special case need for first and last row!!!!!

    last_columns = []   ## by default (on start) all values nil
    chunk = []

    data.each do |row|

      if last_columns.any?   ## note: for first row skip check if values differ
        changed = false
        column_indices.each_with_index do |col,i|
           if row[col] != last_columns[i]
             changed = true
             break   ## out of each_with_index loop
           end
        end

        if changed
         puts "save new chunk:"
         pp last_columns

         chunk_with_headers = chunk.unshift( headers )
         if blk
           ## note: add headers to chunk (with unshift)
           yield( last_columns, chunk_with_headers )
         else
           ## auto-save by default - why? why not?
           split_save( path, last_columns, chunk_with_headers )
         end

         chunk = []
        end
      end

      chunk << row
      last_columns = column_indices.map {|col| row[col] }
    end


    if chunk.any?
      puts "save new chunk:"
      pp last_columns

      chunk_with_headers = chunk.unshift( headers )
      if blk
        yield( last_columns, chunk_with_headers )
      else
        ## auto-save by default - why? why not?
        split_save( path, last_columns, chunk_with_headers )
      end
    end
    puts 'Done.'
  end  ## method self.split



  def self.split_save( inpath, values, chunk )
    basename = File.basename( inpath, '.*' )
    dirname  = File.dirname( inpath )

    ## check/change invalid filename chars
    ##  e.g. change 1990/91 to 1990-91
    extraname = values.map {|value| value.tr('/','-')}.join('~')

    outpath = "#{dirname}/#{basename}_#{extraname}.csv"
    puts "saving >#{basename}_#{extraname}.csv<..."

    CSV.open( outpath, 'w:utf-8' ) do |out|
      chunk.each do |row|
        out << row
      end
    end
  end

end # class CsvUtils
