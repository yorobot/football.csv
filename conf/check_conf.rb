SPORTDB_PATH = '../../../sportdb/sport.db'
## note: use the local version of sportdb gems
$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_PATH}/sportdb-formats/lib" ))
$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_PATH}/sportdb-countries/lib" ))
$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_PATH}/sportdb-leagues/lib" ))
$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_PATH}/sportdb-clubs/lib" ))

$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_PATH}/sportdb-match-formats/lib" ))
$LOAD_PATH.unshift( File.expand_path( "#{SPORTDB_PATH}/sportdb-config/lib" ))



require 'sportdb/readers'  ## fix: use/try sportdb/config !!!!



OPENFOOTBALL_PATH = '../../../openfootball'
## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{OPENFOOTBALL_PATH}/clubs"
SportDb::Import.config.leagues_dir = "#{OPENFOOTBALL_PATH}/leagues"

### "pre-load" leagues & clubs
COUNTRIES      = SportDb::Import.config.countries
LEAGUES        = SportDb::Import.config.leagues
CLUBS          = SportDb::Import.config.clubs
NATIONAL_TEAMS = SportDb::Import.config.national_teams





MATCH_RE = %r{ /(
                  \d{4}-\d{2}   ## (summer/winter) season folder e.g. /2019-20
                   |
                  \d{4}(--[^/]+)?     ## all year season folder e.g. /2019 or /2016--france
                )
                   /[a-z0-9_-]+\.txt$  ## txt e.g /1-premierleague.txt
              }x



def parse( lines )
  start = Date.new( Date.today.year, 6, 1 )   ## fix: use a better date heuristic / guesser
  parser = SportDb::AutoConfParser.new( lines, start )
  parser.parse
end



def find_club_by( name:, country: nil, mapping: nil, warns: nil )
  club_name = name

  if country
    CLUBS.find_by( name: club_name, country: country )
  else  ## assume int'l competition
    m = CLUBS.match( club_name )
    if m
      if m.size > 1
        if mapping[ club_name ]
          ## warn and try again with countr
          if warns
            warns << "WARN: too many name matches (#{m.size}) found for >#{club_name}<"
            ## todo/fix: add / log club matches here too!!!
          end

          values = mapping[ club_name ].split( ',' )
          values = values.map { |value| value.strip }  ## strip all spaces
          club_name_fix, country_fix = values
          CLUBS.find_by( name: club_name_fix, country: country_fix )
        else
          puts "** ERROR: too many name matches for >#{club_name}<:"
          pp m
          exit 1
        end
      else
        m[0]
      end
    else
      nil
    end
  end
end



def read_conf( path,
                lang:,
                country: nil,
                mapping: {},
                exclude: nil,
                include: nil )

  ## track all unmatched lines etc.
  errors = []


  unless File.directory?( path )   ## check if path exists (AND is a direcotry)
    puts "  dir >#{path}< missing; NOT found"
    exit 1
  end

  DateFormats.lang  = lang
  SportDb.lang.lang = lang

  buf     = String.new('')
  sum_buf = String.new('')    ## summary / header buffer

  datafiles = Datafile.find( path, MATCH_RE )
  pp datafiles

  if exclude
    ## filter/select datafiles
    datafiles = datafiles.select {|datafile| !exclude.call(datafile) }
  end

  if include   ## todo/check: is include a reserved keyword????
    ## filter/select datafiles
    datafiles = datafiles.select {|datafile| include.call(datafile) }
  end


  line = "#{datafiles.size} datafiles:\n"
  sum_buf << line; puts line


  country =  COUNTRIES[ country ]   if country  ## map to country_rec - fix: in find_by !!!!

  datafiles.each_with_index do |datafile,i|
    path_rel = datafile[path.length+1..-1]
    line = "[#{i+1}/#{datafiles.size}] >#{path_rel}<\n"
    buf << line; sum_buf << line; puts line

    secs = SportDb::LeagueOutlineReader.read( datafile )
    if secs.size == 0
      line = "  !!! ERROR !!! - NO sections found; 0 sections\n"
      buf << line;  sum_buf << line; puts line
    else
      line = "  #{secs.size} section(s):\n"
      buf << line; sum_buf << line; puts line

      secs.each_with_index do |sec,j|
        sum_line       = String.new('')    ## header line
        sum_more_lines = String.new('')    ##  optional "body" lines listing errors

        line =  "    #{sec[:lines].size} lines - "
        line << "league: >#{sec[:league].name}< (#{sec[:league].key}), "
        line << "season: >#{sec[:season]}<"
        line << ", stage: >#{sec[:stage]}<"  if sec[:stage]

        sum_line << line

        line << "\n"
        buf << line; puts line


        teams, rounds, groups, round_defs, group_defs, extra_lines = parse( sec[:lines ])

        if extra_lines.size > 0
          buf << "!! #{extra_lines.size} unmatched lines:\n"
          extra_lines.each do |line|
             buf << "   >#{line}<\n"
          end

          errors << "#{path_rel}[#{j+1}] - #{extra_lines.size} unmatched lines: #{extra_lines}"
        end


        line = "      #{teams.size} teams:\n"
        buf << line

        ## sort teams by usage
        teams_sorted = teams.to_a.sort do |l,r|
          res =  r[1] <=> l[1]   ## by count
          res =  l[0] <=> r[0]  if res == 0  ## by team name
          res
        end

        team_recs      = []
        team_recs_uniq = {}   ## for reporting duplicate team records

        teams_sorted.each do |rec|
          name, count = rec
          team_rec = nil

          ## try matching club name
          if sec[:league].clubs?
            warns = []
            team_rec = find_club_by( name:    name,
                                     country: country,
                                     mapping: mapping,
                                     warns:   warns )

            if warns.size > 0
              line = warns.join("\n")+"\n"
              buf << line; sum_buf << line

              errors << "#{path_rel}[#{j+1}] - #{warns.join('; ')}"
            end
          else
            team_rec = NATIONAL_TEAMS.find( name )
          end


          if team_rec   ## add if match found
             team_recs << team_rec
             team_recs_uniq[team_rec] ||= []
             team_recs_uniq[team_rec] << name
          end

          line = "     "
          if team_rec.nil?
             line << "!! "

             errors << "#{path_rel}[#{j+1}] - team missing / not found >#{name}<"
          else
             line << "   "
          end

          line << "#{count}× "     if count > 1
          line << "#{name}"

          ## note: only print mapping if team name differs (from canonical team name)
          if team_rec && team_rec.name != name
            line << " ⇒ #{team_rec.name}"
          end

          line << "\n"
          buf << line
          sum_more_lines << line    if team_rec.nil?
        end

        ## check if all club_recs are uniq(ue)
        diff = team_recs.size - team_recs_uniq.size
        if diff > 0
          line = "!! ERROR: #{diff} duplicate team record(s) found\n"
          buf << line; sum_more_lines << line

          ## find duplicate records
          team_recs_uniq.each do |rec, names|
            if names.size > 1
              line = "    #{names.size} duplicate names for >#{rec.name}<:  #{names.join(' | ')}\n"
              buf << line; sum_more_lines << line

              ### fix!!!! use errors << line!!!
              errors["#{path_rel}[#{j+1}]"] ||= {}
              errors["#{path_rel}[#{j+1}]"][:club_duplicates] ||= []
              errors["#{path_rel}[#{j+1}]"][:club_duplicates] << line
            end
          end
        end


        if groups.size > 0
          line = "      #{groups.size} groups:\n"
          buf << line

          groups.each do |group_name, group_hash|
            line = "        "
            line << "#{group_name}"
            line << " ×#{group_hash[:count]}"     if group_hash[:count] > 1
            line << ", #{group_hash[:match_count]} matches"
            line << "\n"
            buf << line
          end
        end

        if round_defs.size > 0
          line = "      #{round_defs.size} round defs:\n"
          buf << line

          round_defs.each do |round_name, _|
            line = "        "
            line << "#{round_name}"
            line << "\n"
            buf << line
          end
        end

        if rounds.size > 0
          line = "      #{rounds.size} rounds:\n"
          buf << line

          rounds.each do |round_name, round_hash|
            line = "        "
            line << "#{round_name}"
            line << " ×#{round_hash[:count]}"     if round_hash[:count] > 1
            line << ", #{round_hash[:match_count]} matches"
            line << "\n"
            buf << line
          end
        end

        sum_line << ", #{teams.size} teams"
        sum_line << ", #{group_defs.size} group def"    if group_defs.size > 0
        sum_line << ", #{groups.size} groups"           if groups.size > 0
        sum_line << ", #{round_defs.size} round defs"   if round_defs.size > 0
        sum_line << ", #{rounds.size} rounds"

        sum_buf << sum_line
        sum_buf << "\n"
        sum_buf << sum_more_lines
      end ## each section
    end
  end

  [sum_buf + "\n\n" + buf, errors]
end


at  = "#{OPENFOOTBALL_PATH}/austria"   ## de
fr  = "#{OPENFOOTBALL_PATH}/france"    ## fr
it  = "#{OPENFOOTBALL_PATH}/italy"     ## it
es  = "#{OPENFOOTBALL_PATH}/espana"    ## es

de  = "#{OPENFOOTBALL_PATH}/deutschland"   ## de
eng = "#{OPENFOOTBALL_PATH}/england"   ## en

br  = "#{OPENFOOTBALL_PATH}/brazil"
ru  = "#{OPENFOOTBALL_PATH}/russia"
mx  = "#{OPENFOOTBALL_PATH}/mexico"

cl  = "#{OPENFOOTBALL_PATH}/europe-champions-league"

euro  = "#{OPENFOOTBALL_PATH}/euro-cup"
world = "#{OPENFOOTBALL_PATH}/world-cup"

# path = eng
# buf = read_conf( path, lang: 'en', country: 'eng' )

# path = de
# buf = read_conf( path, lang: 'de', country: 'de' )

# path = at
# buf = read_conf( path, lang: 'de', country: 'at' )

# path = es
# buf = read_conf( path, lang: 'es', country: 'es' )

# path = fr
# buf = read_conf( path, lang: 'fr', country: 'fr' )

# path = it
# buf = read_conf( path, lang: 'it', country: 'it' )

# path = ru
# buf = read_conf( path, lang: 'en', country: 'ru' )   ## note: use english fallback / default lang for now

# path = br
# buf = read_conf( path, lang: 'pt', country: 'br' )

# path = mx
# buf = read_conf( path, lang: 'es', country: 'mx' )


mapping_cl = {'Arsenal'      => 'Arsenal, ENG',
              'Arsenal FC'   => 'Arsenal, ENG',
              'Liverpool'    => 'Liverpool, ENG',
              'Liverpool FC' => 'Liverpool, ENG',
              'Barcelona'    => 'Barcelona, ESP',
              'Valencia'     => 'Valencia, ESP'}
# path = cl
# buf, errors = read_conf( path, lang: 'en', mapping: mapping_cl,
#                                   exclude: ->(datafile) { datafile =~ /archive/ } )

# path = euro
# buf, errors = read_conf( path, lang: 'en' )

path = world
buf, errors = read_conf( path, lang: 'en' )

puts buf

if errors.size > 0
  puts "#{errors.size} errors / warns:"
  errors.each do |error|
    puts "!! error: #{error}"
  end
end

puts "bye"



## save
File.open( "#{path}/.build/conf.txt", 'w:utf-8' ) do |f|
 f.write( buf )
end
