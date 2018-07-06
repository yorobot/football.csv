# encoding: utf-8



class CsvMatchReader


def self.read( path, headers: nil, filters: nil )

  headers_mapping = {}

  csv = CSV.read( path, headers: true,
                        external_encoding: 'utf-8' )  ## note: always use (assume) utf8 for now

  pp csv

  if headers   ## use user supplied headers if present
    headers_mapping = headers_mapping.merge( headers )
  else

    headers = csv.headers   ## note: returns an array of strings (header names)
    pp headers

    # note: greece 2001-02 etc. use HT  -  check CVS reader  row['HomeTeam'] may not be nil but an empty string?
    #   e.g. row['HomeTeam'] || row['HT'] will NOT work for now

    if find_header( headers, ['Team 1']) && find_header( headers, ['Team 2'])
       ## assume our own football.csv format, see github.com/footballcsv
       headers_mapping[:team1]  = find_header( headers, ['Team 1'] )
       headers_mapping[:team2]  = find_header( headers, ['Team 2'] )
       headers_mapping[:date]   = find_header( headers, ['Date'] )

       ## check for all-in-one full time (ft) and half time (ht9 scores?
       headers_mapping[:score]  = find_header( headers, ['FT'] )
       headers_mapping[:scorei] = find_header( headers, ['HT'] )
    else
       ## else try footballdata.uk and others
       headers_mapping[:team1]  = find_header( headers, ['HomeTeam', 'HT', 'Home'] )
       headers_mapping[:team2]  = find_header( headers, ['AwayTeam', 'AT', 'Away'] )
       headers_mapping[:date]   = find_header( headers, ['Date'] )

       ## note: FT = Full Time, HG = Home Goal, AG = Away Goal
       headers_mapping[:score1] = find_header( headers, ['FTHG', 'HG'] )
       headers_mapping[:score2] = find_header( headers, ['FTAG', 'AG'] )

       ## check for half time scores ?
       ##  note: HT = Half Time
       headers_mapping[:score1i] = find_header( headers, ['HTHG'] )
       headers_mapping[:score2i] = find_header( headers, ['HTAG'] )
    end
  end

  pp headers_mapping

  ### todo/fix: check headers - how?
  ##  if present HomeTeam or HT required etc.
  ##   issue error/warn is not present
  ##
  ## puts "*** !!! wrong (unknown) headers format; cannot continue; fix it; sorry"
  ##    exit 1
  ##

  matches = []

  csv.each_with_index do |row,i|

    puts "[#{i}] " + row.inspect  if i < 2


     if filters    ## filter MUST match if present e.g. row['Season'] == '2017/2018'
       skip = false
       filters.each do |header, value|
         if row[ header ] != value   ## e.g. row['Season']
           skip = true
           break
         end
       end
       next if skip   ## if header values NOT matching
     end


    team1 = row[ headers_mapping[ :team1 ]]
    team2 = row[ headers_mapping[ :team2 ]]


    ## check if data present - if not skip (might be empty row)
    if team1.nil? && team2.nil?
      puts "*** skipping empty? row[#{i}] - no teams found:"
      pp row
      next
    end

    ## remove possible match played counters e.g. (4) (11) etc.
    team1 = team1.sub( /\(\d+\)/, '' ).strip
    team2 = team2.sub( /\(\d+\)/, '' ).strip

    ## reformat team if match  (e.g. Bayern Munich => Bayern München etc.)
    ##  use "global" default/built-in team mappings for now
    team_mappings = SportDb::Import.config.team_mappings
    team1 = team_mappings[ team1 ]   if team_mappings[ team1 ]
    team2 = team_mappings[ team2 ]   if team_mappings[ team2 ]


    date = row[ headers_mapping[ :date ]]

    ## remove possible weekday or weeknumber  e.g. (Fri) (4) etc.
    date = date.sub( /\(\d+\)/, '' )  ## e.g. (4), (21) etc.
    date = date.sub( /\(\w+\)/, '' )  ## e.g. (Fri), (Fr) etc.
    date = date.strip   # make sure not leading or trailing spaces left over

    if date =~ /^\d{2}\/\d{2}\/\d{4}$/
      date_fmt = '%d/%m/%Y'   # e.g. 17/08/2002
    elsif date =~ /^\d{2}\/\d{2}\/\d{2}$/
      date_fmt = '%d/%m/%y'   # e.g. 17/08/02
    elsif date =~ /^\d{4}-\d{2}-\d{2}$/      ## "standard" / default date format
      date_fmt = '%Y-%m-%d'   # e.g. 1995-08-04
    elsif date =~ /^\d{1,2} \w{3} \d{4}$/
      date_fmt = '%d %b %Y'   # e.g. 8 Jul 2017
    else
      puts "*** !!! wrong (unknown) date format >>#{date}<<; cannot continue; fix it; sorry"
      exit 1
    end

    date = Date.strptime( date, date_fmt ).strftime( '%Y-%m-%d' )

    score1  = nil
    score2  = nil
    score1i = nil
    score2i = nil

    ## check for full time scores ?
    if headers_mapping[ :score1 ] && headers_mapping[ :score2 ]
      score1 = row[ headers_mapping[ :score1 ]]
      score2 = row[ headers_mapping[ :score2 ]]
      ## todo: add to_i if not blank? why? why not?
      ##  note: check for blank string!! e.g. "".to_i => 0  (we need nil)
    end

    ## check for half time scores ?
    if headers_mapping[ :score1i ] && headers_mapping[ :score2i ]
      score1i = row[ headers_mapping[ :score1i ]]
      score2i = row[ headers_mapping[ :score2i ]]
      ## todo: add to_i if not blank? why? why not?
    end

    ## check for all-in-one full time scores?
    if headers_mapping[ :score ]
      ft = row[ headers_mapping[ :score ] ]
      if ft =~ /^\d{1,2}-\d{1,2}$/   ## sanity check scores format
        scores = ft.split('-')
        score1 = scores[0].to_i
        score2 = scores[1].to_i
      end
      ## todo/fix: issue warning if non-empty!!! and not matching format!!!!
    end

    if headers_mapping[ :scorei ]
      ht = row[ headers_mapping[ :scorei ] ]
      if ht =~ /^\d{1,2}-\d{1,2}$/   ## sanity check scores format
        scores = ht.split('-')
        score1i = scores[0].to_i
        score2i = scores[1].to_i
      end
      ## todo/fix: issue warning if non-empty!!! and not matching format!!!!
    end


    match = SportDb::Struct::Match.create( date:  date,
                                           team1: team1,     team2: team2,
                                           score1: score1,   score2: score2,
                                           score1i: score1i, score2i: score2i )
    matches << match
  end

  ## pp matches

  ## note: only return team names (not hash with usage counter)
  matches
end



private

def self.find_header( headers, candidates )
  candidates.each do |candidate|
     return candidate if headers.include? candidate  ## bingo!!!
  end
  nil  ## no matching header  found!!!
end

end # class CsvReader
