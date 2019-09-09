
require 'sportdb/config'

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"
SportDb::Import.config.leagues_dir = '../../../openfootball/leagues'


leagues   = SportDb::Import.config.leagues
clubs     = SportDb::Import.config.clubs
countries = SportDb::Import.config.countries

## pp clubs.match( 'Juventus Turin' )
## pp clubs.match_by( name: 'Juventus Turin', country: countries['it'] )



require_relative 'programs'


missing_clubs = {}   ## index by league code


## extra country three-letter code mappings (tipp3 to fifa code)
EXTRA_COUNTRY_MAPPINGS = {
  'SLO' => 'SVN',    ## check if internatial vehicle plates? if yes, auto-include1!!
  'LAT' => 'LVA',
}


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
       ## note: skip handicap tipps - team_1 or team_2 includes +1/+2/+3/+4/+5/-1/-2/-3/..
       if team1 =~ /[+-][12345]/ ||
          team2 =~ /[+-][12345]/          ## note: if - is placed last in character class no need to escape :-)
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
        if league.national?
           ## todo/fix: hack - use a quick hack for now - why? why not?
           ##   todo/fix: allow more than one country in match_by !!!
           ## for league country england     add wales
           ##                       e.g. Cardiff City
           ##                    france      add monaco
           ##                    switzerland add lichtenstein
           club_queries << [team1, league.country]
           club_queries << [team2, league.country]
        else  ## assume int'l tournament
           ##  split name into club name and country e.g.
           ##    LASK Linz AUT    =>  LASK Linz,   AUT
           ##    Club Brügge BEL  =>  Club Brügge, BEL
           teams = [team1, team2]
           teams.each do |team|
             if team =~ /^(.+)[ ]+([A-Z]{3})$/
               country_code = EXTRA_COUNTRY_MAPPINGS[$2] || $2   ## check for corrections / (re)mappings first
               country = countries[ country_code ]
               if country.nil?
                 puts "** !!! ERROR !!! cannot map country code >#{country_code}<; sorry"
                 pp rec
                 exit 1
               end
               club_queries << [$1, country]
             else
               puts "** !!! ERROR !!! three-letter country code missing >#{team1}<; sorry"
               pp rec
               exit 1
             end
           end
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
