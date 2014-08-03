# encoding: utf-8


def convert_csv( path_in, path_out )
  puts ''
  puts "convert >>#{path_in}<< to >>#{path_out}<<"

  csv = CSV.read( path_in, headers: true )

  ### todo/fix: check headers - how?
  ##  if present HomeTeam or HT required etc.
  ##   issue error/warn is not present
  ##
  ## puts "*** !!! wrong (unknown) headers format; cannot continue; fix it; sorry"
  ##    exit 1
  ##


  out = File.new( path_out, 'w' )
  out <<  "Date,Team 1,Team 2,FT,HT\n"  # add header

  csv.each_with_index do |row,i|

    puts "[#{i}] " + row.inspect  if i < 2

    values = []  
    values << row['Date']

    # note: greece 2001-02 etc. use HT  -  check CVS reader  row['HomeTeam'] may not be nil but an empty string?
    #   e.g. row['HomeTeam'] || row['HT'] will NOT work for now
    team1 = row['HomeTeam']
    if team1.nil? || team1.strip.empty?   ## todo: check CVS reader - what does it return for non-existing valules/columns?
      team1 = row['HT']
    end

    team2 = row['AwayTeam']
    if team2.nil? || team2.strip.empty?
      team2 =row['AT']
    end

    values << team1
    values << team2

    ## check if data present - if not skip (might be empty row)
    next if values[0].nil? && values[1].nil? && values[2].nil?  ## no date, no home team, no away team -- skip

    ## reformat date if present
    ##  - from 31/12/00 to 2000-12-31
    
    ##
    ##
    # check date format might be
    #  31/12/00
    # or
    #  17/08/2002  e.g.  E0 for 2002-03
    #
    #  if no match break/exist w/ error

    values[0] = values[0].strip   # make sure not leading or trailing spaces left over

    if values[0] =~ /^\d{2}\/\d{2}\/\d{4}$/
      date_fmt = '%d/%m/%Y'   # e.g. 17/08/2002
    elsif values[0] =~ /^\d{2}\/\d{2}\/\d{2}$/
      date_fmt = '%d/%m/%y'   # e.g. 17/08/02
    else
      puts "*** !!! wrong (unknown) date format >>#{values[0]}<<; cannot continue; fix it; sorry"
      exit 1
    end

    values[0] = Date.strptime( values[0], date_fmt ).strftime( '%Y-%m-%d' )

    ## reformat team if match  (e.g. Bayern Munich => Bayern München etc.)
    values[1] = TEAMS[ values[1] ]   if TEAMS[ values[1] ]
    values[2] = TEAMS[ values[2] ]   if TEAMS[ values[2] ]

    values << "#{row['FTHG']}-#{row['FTAG']}"     # e.g. 1-0  or 3-1 etc. for full time (ft) goals/score

    ## check for half time scores ?
    if row['HTHG'].nil? || row['HTAG'].nil?
      # no (or incomplete) half time socre; add empty
      values << ''
    else
      values << "#{row['HTHG']}-#{row['HTAG']}"
    end
  

    out << values.join( ',' )
    out << "\n"
  end

  out.close
end

