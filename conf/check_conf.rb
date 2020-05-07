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


  ## pass 1: count match (datafile) entries
  entries        = pack.match   ## get all match (datafile) entries

  line = "#{entries.size} datafiles:\n"
  sum_buf << line

  entries.each_with_index do |entry,i|
    puts entry.name
    errors_entry = []    ## track local errors; see errors for all

    secs = SportDb::LeagueOutlineReader.parse( entry.read )

    header_line = "[#{i+1}/#{entries.size}] >#{entry.name}< - #{secs.size} section(s):\n"
    buf     << header_line
    sum_buf << header_line

    if secs.size == 0
      sum_buf << "  !! ERROR: NO sections found\n"
      next
    end

      secs.each_with_index do |sec,j|
        sum_line       = String.new('')    ## header line

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
        line << "#{league.name} (#{league.key}) "
        line << "#{season.key}"
        line << ", stage: >#{stage}<"  if stage

        sum_line << line

        line << "\n"
        buf << line

        if extra_lines.size > 0
          buf << "!! #{extra_lines.size} unmatched lines:\n"
          extra_lines.each do |line|
             buf << "   >#{line}<\n"
          end

          errors_entry << "WARN: #{extra_lines.size} unmatched lines: #{extra_lines}"
        end


        buf << "      #{teams.size} teams (referenced):\n"

        buf_teams, errors_teams = check_teams( teams, league: league, mods: mods)
        buf          << buf_teams
        errors_entry += errors_teams


        if groups.size > 0
          buf << "      #{groups.size} groups (referenced):\n"

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
          buf << "      #{round_defs.size} rounds (defined):\n"

          round_defs.each do |round_name, _|
            line = "        "
            line << "#{round_name}"
            line << "\n"
            buf << line
          end
        end

        if rounds.size > 0
          buf << "      #{rounds.size} rounds (referenced):\n"

          rounds.each do |round_name, round_hash|
            line = "        "
            line << "#{round_name}"
            line << " ×#{round_hash[:count]}"     if round_hash[:count] > 1
            line << ", #{round_hash[:match_count]} matches"
            line << "\n"
            buf << line
          end
        end

        sum_line << ", #{teams.size} team refs"
        sum_line << ", #{group_defs.size} group defs"    if group_defs.size > 0
        sum_line << ", #{groups.size} group refs"        if groups.size > 0
        sum_line << ", #{round_defs.size} round defs"    if round_defs.size > 0
        sum_line << ", #{rounds.size} round defs"

        sum_buf << sum_line
        sum_buf << "\n"

        if errors_entry.size > 0
          sum_buf << "  !! #{errors_entry.size} error(s) / warn(s):\n"

          errors_entry.each do |error|
            sum_buf << "    #{error}\n"
            errors << "#{entry.name}[#{j+1}] - #{error}"
          end
        end

      end  # each sec
  end  # each entry

  [sum_buf + "\n\n" + buf, errors]
end


def check_teams( team_usage, league:, mods: )
  buf    = String.new('')
  errors = []

  ## sort teams by usage
  team_usage_sorted = team_usage.to_a.sort do |l,r|
          res =  r[1] <=> l[1]   ## by count
          res =  l[0] <=> r[0]  if res == 0  ## by team name
          res
  end

  team_recs      = []
  team_recs_uniq = {}   ## for reporting duplicate team records

  team_usage_sorted.each do |team_usage_rec|
     name, count = team_usage_rec

     ## try matching club name
     team_rec = if league.clubs?
                  if mods && mods[ name ]
                    ## double check for too many machtes warning
                    m = CLUBS.match( name )
                    if m && m.size > 1
                      line = "WARN: too many name matches (#{m.size}) found for >#{name}<"
                      ## todo/fix: add / log club matches here too!!!
                      buf << "!! #{line}\n"
                      errors << "#{line}"
                    end
                    mods[ name ]
                  else
                    CLUBS.find_by( name: name, country: league.country )
                  end
                else
                  NATIONAL_TEAMS.find( name )
                end


    if team_rec   ## add if match found
      team_recs << team_rec

      team_recs_uniq[team_rec] ||= []
      team_recs_uniq[team_rec] << name
    end

    ## start print team new line
    buf << "     "
    if team_rec.nil?
      errors << "ERROR: team missing / not found >#{name}<"

      buf << "!! "
    else
      buf << "   "
    end

    buf << "#{count}× "     if count > 1
    buf << "#{name}"

    ## note: only print mapping if team name differs (from canonical team name)
    if team_rec && team_rec.name != name
      buf << " ⇒ #{team_rec.name}"
    end
    buf << "\n"
  end  # each team


  ## check if all team recs are uniq(ue)
  diff = team_recs.size - team_recs_uniq.size
  if diff > 0
      buf << "!! ERROR: #{diff} duplicate team record(s) found:\n"

      ## find duplicate records
      team_recs_uniq.each do |rec, names|
        if names.size > 1
          msg = "#{names.size} duplicate names for >#{rec.name}<: #{names.join(' | ')}"
          buf << "   #{msg}\n"

          errors << "WARN: #{msg}"
        end
      end
  end

  [buf, errors]
end  # method check_teams




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
  'eng' => [eng, { lang: 'en' }],
  'de'  => [de,  { lang: 'de' }],
  'at'  => [at,  { lang: 'de' }],
  'es'  => [es,  { lang: 'es' }],
  'fr'  => [fr,  { lang: 'fr' }],
  'it'  => [it,  { lang: 'it' }],
  'ru'  => [ru,  { lang: 'en' }],   ## note: use english fallback / default lang for now

  'br'  => [br,  { lang: 'pt' }],
  'mx'  => [mx,  { lang: 'es' }],

  'cl'  => [cl,  { lang: 'en', mods: mods }],

  'euro'  => [euro,  { lang: 'en' }],
  'world' => [world, { lang: 'en' }],
}


def print_errors( errors )
  if errors.size > 0
    puts "#{errors.size} error(s) / warn(s):"
    errors.each do |error|
      puts "!! ERROR: #{error}"
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

