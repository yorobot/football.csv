# encoding: utf-8


class CsvUtils

  def self.stat( path, *columns, sep: ',' )

    ## dump headers first (first row with names of columns)
    headers = CsvUtils.header( path, sep: sep )
    puts "#{headers.size} headers:"
    headers.each_with_index do |header,i|
      puts "  #{i+1}: #{header}"
    end


    csv_options = { headers: true,
                    col_sep: sep
                    ## todo/fix: always (auto-)add utf-8 external encoding!!!
                  }

    values = {}
    nulls  = {}
    # check 1) nulls/nils (e.g. empty strings ""),
    #       2) not/appliation or available  n/a NA or NaN or ...
    #       3) missing - e.g. ?

    i=0
    CSV.foreach( path, csv_options ) do |row|
      i += 1

      pp row    if i == 1

      print '.' if i % 100 == 0

      ## collect unique values for passed in columns
      columns.each do |col|
        value = row[col]    ## note: value might be nil!!!!!
        value = value.strip   if value   ## use strip - why? why not? report/track trailing spaces?

        values[col] ||= Hash.new(0)
        values[col][ value ? value : '<nil>' ] +=1
      end

      ## alway track nulls - why? why not
      row.each do |col,value|
        ## if value.nil?    ## todo/check - nil value possible (not always empty string - why? why not?)
        ##   puts "[debug] nil value in row:"
        ##   puts "#{col} = #{value.inspect} : #{value.class.name}"
        ## end

        value = value.strip   if value   ## use strip - why? why not? report/track trailing spaces?
        if value.nil?
          nulls[col] ||= Hash.new(0)
          nulls[col]['nil'] +=1
        elsif value.empty?
          nulls[col] ||= Hash.new(0)
          nulls[col]['empty'] +=1
        elsif ['na', 'n/a', '-'].include?( value.downcase )
          nulls[col] ||= Hash.new(0)
          nulls[col]['na'] +=1
        elsif value == '?'    ## check for (?) e.g. value.include?( '(?)') - why? why not?
          nulls[col] ||= Hash.new(0)
          nulls[col]['?'] +=1
        else
          # do nothing; "regular" value
        end
      end
    end

    puts " #{i} rows"
    puts "nils/nulls :: empty strings :: na / n/a / undefined :: missing (?):"
    pp nulls

    if values.any?
       ## pretty print (pp) / dump unique values for passed in columns
       values.each do |col,h|
         puts " column >#{col}< #{h.size} unique values:"
         ## sort by name/value for now (not frequency) - change - why? why not?
         sorted_values = h.to_a.sort {|l,r| l[0] <=> r[0] }
         sorted_values.each do |rec|
           puts "   #{rec[1]} x  #{rec[0]}"
         end
       end
    end
  end # method self.stat

end  # class CsvUtils
