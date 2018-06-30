# encoding: utf-8


####
#  load / import csv file into football.db database

## step 1
##   find all teams
##   find season for auto-creating event/season/teams etc.

##
##  todo/fix: always use utf8 in file read/write!!!



## unify team names; team (builtin/known/shared) name mappings
TEAMS = { }




MatchStruct = Struct.new( :date,
                          :team1,   :team2,
                          :score1,  :score2,
                          :score1i, :score2i)    ## rename to MatchRow, MatchTxt, etc. - why? why not?


def find_header( headers, candidates )
  candidates.each do |candidate|
     return candidate if headers.include? candidate  ## bingo!!!
  end
  nil  ## no matching header  found!!!
end


def find_matches_in_txt( path, headers: nil, filters: nil )

  headers_mapping = {}

  csv = CSV.read( path, headers: true )


  pp csv

  if headers   ## use user supplied headers if present
    headers_mapping = headers_mapping.merge( headers )
  else

    headers = csv.headers   ## note: returns an array of strings (header names)
    pp headers

    # note: greece 2001-02 etc. use HT  -  check CVS reader  row['HomeTeam'] may not be nil but an empty string?
    #   e.g. row['HomeTeam'] || row['HT'] will NOT work for now

    headers_mapping[:team1]  = find_header( headers, ['Team 1', 'Team.1', 'HomeTeam', 'HT', 'Home'] )
    headers_mapping[:team2]  = find_header( headers, ['Team 2', 'Team.2', 'AwayTeam', 'AT', 'Away'] )
    headers_mapping[:date]   = find_header( headers, ['Date'] )

    ## note: FT = Full Time, HG = Home Goal, AG = Away Goal
    headers_mapping[:score1] = find_header( headers, ['FTHG', 'HG'] )
    headers_mapping[:score2] = find_header( headers, ['FTAG', 'AG'] )

    ## check for half time scores ?
    ##  note: HT = Half Time
    headers_mapping[:score1i] = find_header( headers, ['HTHG'] )
    headers_mapping[:score2i] = find_header( headers, ['HTAG'] )
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

    ## reformat team if match  (e.g. Bayern Munich => Bayern München etc.)
    team1 = TEAMS[ team1 ]   if TEAMS[ team1 ]
    team2 = TEAMS[ team2 ]   if TEAMS[ team2 ]

    ## check if data present - if not skip (might be empty row)
    if team1.nil? && team2.nil?
      puts "*** skipping empty? row[#{i}] - no teams found:"
      pp row
      next
    end

    date = row[ headers_mapping[ :date ]]

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


    score1 = row[ headers_mapping[ :score1 ]]
    score2 = row[ headers_mapping[ :score2 ]]

    ## check for half time scores ?
    if headers_mapping[ :score1i ] && headers_mapping[ :score2i ]
      score1i = row[ headers_mapping[ :score1i ]]
      score2i = row[ headers_mapping[ :score2i ]]
    else
      score1i = nil
      score2i = nil
    end


    match = MatchStruct.new( date,
                             team1,  team2,
                             score1, score2,
                             score1i, score2i )
    matches << match
  end

  ## pp matches

  ## note: only return team names (not hash with usage counter)
  matches
end



def find_teams_in_matches_txt( matches )

  teams = Hash.new( 0 )   ## default value is 0

  matches.each_with_index do |match,i|
    teams[ match.team1 ] += 1
    teams[ match.team2 ] += 1
  end

  pp teams

  ## note: only return team names (not hash with usage counter)
  teams.keys
end




def find_seasons_in_txt( path )

  seasons = Hash.new( 0 )   ## default value is 0

  csv = CSV.read( path, headers: true )

  csv.each_with_index do |row,i|
    puts "[#{i}] " + row.inspect  if i < 2

    season = row['Season']
    seasons[ season ] += 1
  end

  pp seasons

  ## note: only return season keys/names (not hash with usage counter)
  seasons.keys
end
