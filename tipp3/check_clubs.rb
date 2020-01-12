
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


league_titles = {}   ## lookup league title by league code

PROGRAMS_2020.each do |program|
   recs = CsvHash.read( "o/#{program}.csv", :header_converters => :symbol )
   pp recs.size


   recs.each do |rec|
     league_code  = EXTRA_LEAGUE_MAPPINGS[ rec[:liga] ] || rec[:liga]    ## check for corrections / (re)mappings first
     league_title = rec[:liga_title]

     next if HOCKEY_LEAGUES.include?( league_code ) ||     ## skip (ice) hockey leagues
             BASKETBALL_LEAGUES.include?( league_code ) ||
             HANDBALL_LEAGUES.include?( league_code ) ||
             MORE_LEAGUES.include?( league_code ) ||      ## skip amercian football, etc.
             WINTER_LEAGUES.include?( league_code )       ## skip ski alpin 

     ## skip national (selection) teams / matches e.g. wm, em, u21, u20, int fs, etc.
     next if EXCLUDE_LEAGUES.include?( league_code )

      ## remove leading "Fussball -" from title (before 2020 format change)   
      league_title = league_title.sub('Fussball - ','')  if league_title =~ %r{Fussball -}


       league_titles[ league_code ] = league_title

       team1 = rec[:team_1]
       team2 = rec[:team_2]
       ## remove possible (*) marker e.g. Atalanta Bergamo*
       team1 = team1.gsub( '*', '' )
       team2 = team2.gsub( '*', '' )

       ## skip matches with  possible +1/+2/+3/+4/+5/-1/-2/-3/.. handicap
       if team1 =~ /[+-][12345]/ ||
          team2 =~ /[+-][12345]/
          puts "skip match with handicap"   # note: int'l matches with handicap miss three-letter country code
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

           ## quick hack: check for known exceptions; fix missing country codes
           teams = teams.map do |team|
              if team == 'Al Hilal FC'   ## used in 2019-51a_tue-dec-17 for KLUB WM
                team = 'Al Hilal FC KSA'
              elsif team == 'CF Monterrey'
                team = 'CF Monterrey MEX' ## used in 2019-51a_tue-dec-17 for KLUB WM
              else
                team
              end
           end

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
               puts "** !!! ERROR !!! three-letter country code missing >#{team}<; sorry"
               pp rec
               pp league   ## note: also print league to help debugging
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
            m = clubs.match_by( name: name, country: countries['nir'])  if country.key == 'ie'
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


puts "missing (unmatched) clubs:"
pp missing_clubs

puts "pretty print:"
buf = String.new
missing_clubs.each do |league, names|
  buf << "League #{league} (#{names.size}) - >#{league_titles[league]}<:\n"
  names.each do |name|
    buf << "  #{name}\n"
  end
end

puts buf

## save to missing_clubs.txt
File.open( 'missing_clubs.txt', 'w:utf-8' ) do |f|
  f.write buf
end
