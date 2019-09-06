
require_relative 'league_reader'



recs = LeagueReader.read( 'leagues.txt' )
pp recs

leagues = LeagueIndex.new
leagues.add( recs )
leagues.dump_duplicates

clubs = SportDb::Import.config.clubs



require_relative 'programs'


PROGRAMS.each do |program|
   recs = CsvHash.read( "2019-#{program}.csv", :header_converters => :symbol )
   pp recs.size


   recs.each do |rec|
     league       = rec[:liga]
     league_title = rec[:liga_title]

     if rec[:liga_title] =~ /Fussball/
       ## note: skip handicap tipps - team_1 or team_2 includes +1 or +2
       if rec[:team_1] =~ /\+[12]/ ||
          rec[:team_2] =~ /\+[12]/
          puts "skip tip with handicap:"
          pp rec
          next
       end

       m = leagues.match( rec[:liga] )
       if m
         league = m[0]
         ## try matching clubs
         if league.country
            m2 = clubs.match_by( name: rec[:team_1], country: league.country )
         else
           ## intl
           ##  get country from club !!!
         end

         if m2.nil?
           puts "** !!WARN!! no match for club <#{rec[:team_1]}>:"
           pp rec
         end
         ## todo check for more than one match

       else
         puts "** !!WARN!! no match for league <#{rec[:liga]}>:"
         pp rec
       end
     end
   end
end
