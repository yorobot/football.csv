# encoding: utf-8


def convert_csv( path_in, path_out )
  puts ''
  puts "convert >>#{path_in}<< to >>#{path_out}<<"


   ## use new CsvMatchReader
   matches_txt = CsvMatchReader.read( path_in )

  ### todo/fix: check headers - how?
  ##  if present HomeTeam or HT required etc.
  ##   issue error/warn is not present
  ##
  ## puts "*** !!! wrong (unknown) headers format; cannot continue; fix it; sorry"
  ##    exit 1
  ##



  out = File.new( path_out, 'w' )    ## fix: use utf8!!!!!!!
  out <<  "Date,Team 1,Team 2,FT,HT\n"  # add header

  matches_txt.each_with_index do |match,i|

    if i < 2
       puts "[#{i}]:" + match.inspect
    end


    values = []
    values << match.date     ## note: assumes string for now e.g. 2018-11-22

    values << match.team1
    values << match.team2

    if match.score1 && match.score2
      values << match.score_str
    else
      # no (or incomplete) full time score; add empty
      values << ''
    end

    if match.score1i && match.score2i
      values << match.scorei_str
    else
      # no (or incomplete) half time score; add empty
      values << ''
    end

    out << values.join( ',' )
    out << "\n"
  end

  out.close
end
