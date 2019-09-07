
require_relative 'league_reader'


## use (switch to) "external" clubs datasets
SportDb::Import.config.clubs_dir = "../../../openfootball/clubs"


recs = LeagueReader.read( 'leagues.txt' )
pp recs

leagues = LeagueIndex.new
leagues.add( recs )
leagues.dump_duplicates


clubs = SportDb::Import.config.clubs

countries = SportDb::Import.config.countries

## pp clubs.match( 'Juventus Turin' )
## pp clubs.match_by( name: 'Juventus Turin', country: countries['it'] )



require_relative 'programs'


missing_clubs = {}   ## index by league code


PROGRAMS.each do |program|
   recs = CsvHash.read( "2019-#{program}.csv", :header_converters => :symbol )
   pp recs.size


   recs.each do |rec|
     league_code  = rec[:liga]
     league_title = rec[:liga_title]

     if league_title =~ /Fussball/

       team1 = rec[:team_1]
       team2 = rec[:team_2]
       ## remove possible (*) marker e.g. Atalanta Bergamo*
       team1 = team1.gsub( '*', '' )
       team2 = team2.gsub( '*', '' )

       ## fix: add +3 to html_to_txt to - check if it is possible to share code?
       ## note: skip handicap tipps - team_1 or team_2 includes +1/+2/+3/-1/-2/-3
       if team1 =~ /[+-][123]/ ||
          team2 =~ /[+-][123]/          ## note: if - is placed last in character class no need to escape :-)
          puts "skip tip with handicap:"
          pp rec
          next
       end

       m = leagues.match( league_code )
       if m
         league = m[0]
       else
         puts "** !!ERROR!! no match for league <#{league_code}>:"
         pp rec
         exit 1
       end

        ## try matching clubs
        club_queries = []
        if league.country
           ## todo/fix: hack - use a quick hack for now - why? why not?
           ##   todo/fix: allow more than one country in match_by !!!
           ## for league country england     add wales
           ##                       e.g. Cardiff City
           ##                    france      add monaco
           ##                    switzerland add lichtenstein
           club_queries << [team1, league.country]
           club_queries << [team2, league.country]
        else
           ## intl
           ##  get country from club !!!
        end

        club_queries.each do |q|
          name    = q[0]
          country = q[1]

          m = clubs.match_by( name: name, country: country )

          if m.nil? && league.national?
            ## (re)try with second country - quick hacks for known leagues
            m = clubs.match_by( name: name, country: countries['wal'])  if country.key == 'eng'
            m = clubs.match_by( name: name, country: countries['mc'])   if country.key == 'fr'
            m = clubs.match_by( name: name, country: countries['li'])   if country.key == 'ch'
            m = clubs.match_by( name: name, country: countries['ca'])   if country.key == 'us'
          end

          if m.nil?
             puts "** !!WARN!! no match for club <#{name}>:"
             pp rec

             missing_clubs[ league_code ] ||= []

             if league.intl?
               full_name = "#{name}, #{country.name} (#{country.key})"
             else   ## just use name for national league
               full_name = "#{name}"
             end

             if missing_clubs[ league_code ].include?( full_name )
               puts "  skip missing club #{full_name}; already included"
             else
               missing_clubs[ league_code ] << full_name
             end
          elsif m.size > 1
            puts "** !!WARN!! too many matches (#{m.size}) for club <#{name}>:"
            pp m
            pp rec
            exit 1
          else
            # bingo; match
          end
        end
     end
   end
end

puts "missing (unmatched) clubs:"
pp missing_clubs

puts "pretty print:"
missing_clubs.each do |league, names|
  puts "League #{league} (#{names.size}):"
  names.each do |name|
    puts "  #{name}"
  end
end
