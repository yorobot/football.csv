

country = find_country( 'fr' )
league  = find_league( 'fr' )


country = find_country( 'eng' )
league  = find_league( 'en' )


## seasons_txt = ['2017-18', '2016-17' ]
## seasons_txt = ['2017-18']
seasons_txt = ['2013-14']

seasons_txt.each do |season_txt|
   matches_txt = find_matches_in_txt( "./dl/eng-england/#{season_txt}/E0.csv" )
   puts "#{matches_txt.size} matches:"

   teams_txt = find_teams_in_matches_txt( matches_txt )
   puts "#{teams_txt.size} teams:"
   pp teams_txt

   teams   = find_teams( teams_txt, country: country )

   season  = find_season( season_txt )
   event   = find_event( season: season, league: league )

   ## add teams to event
   ##   todo/fix: check if team is alreay included?
   ##    or clear/destroy_all first!!!
   teams.each do |team|
     event.teams << team
   end

   ## add catch-all/unclassified "dummy" round
   round = SportDb::Model::Round.create!(
      event_id: event.id,
      title:    'Matchday ??? / Missing / Catch-All',   ## find a better name?
      pos:      999,
      start_at: event.start_at.to_date
    )

    ## add matches

    ## build hash lookup table e.g.
    #  { 'Liverpool' => obj, ... }
    teams_mapping = Hash[ teams_txt.zip( teams ) ]

    matches_txt.each do |match_txt|
       team1 = teams_mapping[match_txt.team1]
       team2 = teams_mapping[match_txt.team2]

       match = SportDb::Model::Game.create!(
         team1_id: team1.id,
         team2_id: team2.id,
         round_id: round.id,
         pos:      999,    ## make optional why? why not? - change to num?
         play_at:  Date.strptime( match_txt.date, '%Y-%m-%d' ),
         score1:   match_txt.score1,
         score2:   match_txt.score2,
         score1i:  match_txt.score1i,
         score2i:  match_txt.score2i,
       )
       pp match
    end
end
