require_relative 'boot'



def parse( lines, start: )
  parser = SportDb::AutoConfParser.new( lines, start )
  parser.parse
end

def parse_match( lines, teams, start: )
  parser = SportDb::MatchParserSimpleV2.new( lines, teams, start )
  parser.parse
end



def read_conf( path,
                lang:,
                country: nil,
                mods: nil,
                exclude: nil,
                include: nil )

  ## track all unmatched lines etc.
  errors = []

  pack = SportDb::Package.new( path )
  pack.include = include
  pack.exclude = exclude

  SportDb::Import.config.lang = lang


  buf     = String.new('')    ## fix: use Buffer.new !!!! check string lang utils?
  sum_buf = String.new('')    ## summary / header buffer


  country =  COUNTRIES.find( country )   if country  ## map to country_rec - fix: in find_by !!!!



  ## pass 1: count datafiles
  datafile_count = pack.match_count

  line = "#{datafile_count} datafiles:\n"
  sum_buf << line


  pack.each_match_with_index do |entry,i|
    puts entry.name

    secs = SportDb::LeagueOutlineReader.parse( entry.read )

    header_line = "== [#{i+1}/#{datafile_count}] >#{entry.name}< - #{secs.size} section(s) ==\n"
    buf     << header_line
    sum_buf << header_line

    if secs.size == 0
      sum_buf << "  !!! ERROR !!! - NO sections found; 0 sections\n"
      next
    end

      secs.each_with_index do |sec,j|
        sum_line       = String.new('')    ## header line
        sum_more_lines = String.new('')    ##  optional "body" lines listing errors

        lines  = sec[:lines]
        league = sec[:league]
        season = sec[:season]
        stage  = sec[:stage]


        start  = if season.year?
                   Date.new( season.start_year, 1, 1 )
                 else
                  ## use 6,1  - why? why not?
                   Date.new( season.start_year, 7, 1 )
                 end

        teams, rounds, groups, round_defs, group_defs, extra_lines = parse( lines, start: start )

        ### also try parse and check for errors
        ##  todo: check for more stats and errors
        ##   returns matches, rounds, groups
        matches, _ = parse_match( lines, teams.keys, start: start )


        line =  "    #{lines.size} lines, #{matches.size} matches - "
        line << "league: >#{league.name}< (#{league.key}), "
        line << "season: >#{season.key}<"
        line << ", stage: >#{stage}<"  if stage

        sum_line << line

        line << "\n"
        buf << line

        if extra_lines.size > 0
          buf << "!! #{extra_lines.size} unmatched lines:\n"
          extra_lines.each do |line|
             buf << "   >#{line}<\n"
          end

          errors << "#{entry.name}[#{j+1}] - #{extra_lines.size} unmatched lines: #{extra_lines}"
        end


        buf << "      #{teams.size} teams:\n"

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
            team_rec = if mods && mods[ name ]
                         ## double check for too many machtes warning
                         m = CLUBS.match( name )
                         if m && m.size > 1
                          line = "WARN: too many name matches (#{m.size}) found for >#{name}<"
                          ## todo/fix: add / log club matches here too!!!
                          buf << line; sum_buf << line
                          errors << "#{entry.name}[#{j+1}] - #{line}"
                         end
                         mods[ name ]
                       else
                         CLUBS.find_by( name: name, country: country )
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

             errors << "#{entry.name}[#{j+1}] - team missing / not found >#{name}<"
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

              errors << "#{entry.name}[#{j+1}] #{line}"
            end
          end
        end


        if groups.size > 0
          buf << "      #{groups.size} groups:\n"

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
          buf << "      #{round_defs.size} round defs:\n"

          round_defs.each do |round_name, _|
            line = "        "
            line << "#{round_name}"
            line << "\n"
            buf << line
          end
        end

        if rounds.size > 0
          buf << "      #{rounds.size} rounds:\n"

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
      end  # each sec
  end  # each entry

  [sum_buf + "\n\n" + buf, errors]
end







## champions league mods
mods = CLUBS.build_mods({
'Arsenal   | Arsenal FC'    => 'Arsenal, ENG',
'Liverpool | Liverpool FC'  => 'Liverpool, ENG',
'Barcelona'                 => 'Barcelona, ESP',
'Valencia'                  => 'Valencia, ESP'
})


eng = "#{OPENFOOTBALL_PATH}/england"   ## en
de  = "#{OPENFOOTBALL_PATH}/deutschland"   ## de
at  = "#{OPENFOOTBALL_PATH}/austria"   ## de
es  = "#{OPENFOOTBALL_PATH}/espana"    ## es
fr  = "#{OPENFOOTBALL_PATH}/france"    ## fr
it  = "#{OPENFOOTBALL_PATH}/italy"     ## it
ru  = "#{OPENFOOTBALL_PATH}/russia"

br  = "#{OPENFOOTBALL_PATH}/brazil"
mx  = "#{OPENFOOTBALL_PATH}/mexico"

cl  = "#{OPENFOOTBALL_PATH}/europe-champions-league"

euro  = "#{OPENFOOTBALL_PATH}/euro-cup"
world = "#{OPENFOOTBALL_PATH}/world-cup"


datasets = {
  'eng' => [eng, { lang: 'en', country: 'eng' }],
  'de'  => [de,  { lang: 'de', country: 'de' }],
  'at'  => [at,  { lang: 'de', country: 'at' }],
  'es'  => [es,  { lang: 'es', country: 'es' }],
  'fr'  => [fr,  { lang: 'fr', country: 'fr' }],
  'it'  => [it,  { lang: 'it', country: 'it' }],
  'ru'  => [ru,  { lang: 'en', country: 'ru' }],   ## note: use english fallback / default lang for now

  'br'  => [br,  { lang: 'pt', country: 'br' }],
  'mx'  => [mx,  { lang: 'es', country: 'mx' }],

  'cl'  => [cl,  { lang: 'en', mods: mods }],

  'euro'  => [euro,  { lang: 'en' }],
  'world' => [world, { lang: 'en' }],
}


def print_errors( errors )
  if errors.size > 0
    puts "#{errors.size} error(s) / warn(s):"
    errors.each do |error|
      puts "!! error: #{error}"
    end
  else
    puts "#{errors.size} errors / warns"
  end
end


if ARGV.size > 0

  dataset = datasets[ ARGV[0] ]

  path   = dataset[0]
  kwargs = dataset[1]

  buf, errors = read_conf( path, exclude: /archive/,
                                 **kwargs )
  puts buf
  puts
  print_errors( errors )

## save
# out_path = "#{path}/.build/conf.txt"
out_path = "./tmp/conf.txt"
File.open( out_path , 'w:utf-8' ) do |f|
 f.write( buf )
end

else    ## check all
errors_by_dataset = []

datasets.values.each do |dataset|
  path   = dataset[0]
  kwargs = dataset[1]

  buf, errors = read_conf( path, exclude: /archive/,
                                 **kwargs )
  puts buf

  errors_by_dataset << [File.basename(path), errors]
end


errors_by_dataset.each do |rec|
  dataset = rec[0]
  errors  = rec[1]

  puts
  puts "==== #{dataset} ===="

  print_errors( errors )
end
end

puts "bye"

