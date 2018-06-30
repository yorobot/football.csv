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



def find_matches_in_txt( path, season: nil )

  matches = []

  csv = CSV.read( path, headers: true )

  ### todo/fix: check headers - how?
  ##  if present HomeTeam or HT required etc.
  ##   issue error/warn is not present
  ##
  ## puts "*** !!! wrong (unknown) headers format; cannot continue; fix it; sorry"
  ##    exit 1
  ##

  csv.each_with_index do |row,i|

    puts "[#{i}] " + row.inspect  if i < 2


     if season    ## filter for season?
       next if row['Season'] != season
     end


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


    match = MatchStruct.new( date,
                             team1,  team2,
                             score1, score2,
                             score1i, score2i )
    matches << match
  end

  pp matches

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
