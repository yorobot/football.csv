
    # note: greece 2001-02 etc. use HT  -  check CVS reader  row['HomeTeam'] may not be nil but an empty string?
    #   e.g. row['HomeTeam'] || row['HT'] will NOT work for now
    team1 = row['HomeTeam']
    team1 = row['HT']        if team1.nil? || team1.strip.empty?   ## todo: check CVS reader - what does it return for non-existing valules/columns?
    team1 = row['Home']      if team1.nil? || team1.strip.empty?


    team2 = row['AwayTeam']
    team2 = row['AT']        if team2.nil? || team2.strip.empty?
    team2 = row['Away']      if team2.nil? || team2.strip.empty?



    ## reformat team if match  (e.g. Bayern Munich => Bayern München etc.)
    team1 = TEAMS[ team1 ]   if TEAMS[ team1 ]
    team2 = TEAMS[ team2 ]   if TEAMS[ team2 ]

    ## check if data present - if not skip (might be empty row)
    if team1.nil? && team2.nil?
      puts "*** skipping empty? row[#{i}] - no teams found:"
      pp row
      next
    end

    date = row['Date']

    date = date.strip   # make sure not leading or trailing spaces left over

    if date =~ /^\d{2}\/\d{2}\/\d{4}$/
      date_fmt = '%d/%m/%Y'   # e.g. 17/08/2002
    elsif date =~ /^\d{2}\/\d{2}\/\d{2}$/
      date_fmt = '%d/%m/%y'   # e.g. 17/08/02
    else
      puts "*** !!! wrong (unknown) date format >>#{date}<<; cannot continue; fix it; sorry"
      exit 1
    end

    date = Date.strptime( date, date_fmt ).strftime( '%Y-%m-%d' )


    score1 = row['FTHG']
    score1 = row['HG']     if score1.nil? || score1.strip.empty?

    score2 = row['FTAG']
    score2 = row['AG']     if score2.nil? || score2.strip.empty?


    ## check for half time scores ?
    score1i = row['HTHG']
    score2i = row['HTAG']
