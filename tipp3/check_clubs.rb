
require_relative 'league_reader'



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
     league       = rec[:liga]
     league_title = rec[:liga_title]

     if rec[:liga_title] =~ /Fussball/
       ## fix: add +3 to html_to_txt to - check if it is possible to share code?
       ## note: skip handicap tipps - team_1 or team_2 includes +1 or +2
       if rec[:team_1] =~ /\+[123]/ ||
          rec[:team_2] =~ /\+[123]/
          puts "skip tip with handicap:"
          pp rec
          next
       end

       m = leagues.match( rec[:liga] )
       if m
         league = m[0]
       else
         puts "** !!ERROR!! no match for league <#{rec[:liga]}>:"
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
           club_queries << [rec[:team_1], league.country]
           club_queries << [rec[:team_2], league.country]
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

             missing_clubs[ rec[:liga] ] ||= []

             full_name = "#{name}, #{country.name} (#{country.key})"

             if missing_clubs[ rec[:liga] ].include?( full_name )
               puts "  skip missing club #{full_name}; already included"
             else
               missing_clubs[ rec[:liga] ] << full_name
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
