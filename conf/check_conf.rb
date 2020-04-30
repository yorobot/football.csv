require_relative 'boot'



def parse( lines )
  start = Date.new( Date.today.year, 6, 1 )   ## fix: use a better date heuristic / guesser
  parser = SportDb::AutoConfParser.new( lines, start )
  parser.parse
end




def find_club_by( name:, country: nil, mapping: nil, warns: nil )

  if mapping && mapping[ name ]
    ## todo/fix: check for warn too many matches or no match etc. -why? why not?
    if warns
      m = CLUBS.match( name )
      if m && m.size > 1
         warns << "WARN: too many name matches (#{m.size}) found for >#{name}<"
        ## todo/fix: add / log club matches here too!!!
      end
    end

    mapping[ name ]
  else
    CLUBS.find_by( name: name, country: country )
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

  pack = SportDb::Package.new( path )

  SportDb::Import.config.lang = lang


  buf     = String.new('')    ## fix: use Buffer.new !!!! check string lang utils?
  sum_buf = String.new('')    ## summary / header buffer


  country =  COUNTRIES.find( country )   if country  ## map to country_rec - fix: in find_by !!!!

  ##
  ##  todo/fix: use pack.exclude =
  ##            use pack.include =
  ##   and than use "internal" filter method - why? why not?


  filter = ->(entry) do
    if include
      if include.call( entry.name )   ## todo/check: is include a reserved keyword????
        true  ## todo/check: check for exclude here too - why? why not?
      else
        false
      end
    else
      if exclude && exclude.call( entry.name )
        false
      else
        true
      end
    end
  end


  ## pass 1: collect datafiles
  datafiles = []
  pack.each_match do |entry|
    puts entry.name

    ## filter/select datafiles
    next  unless filter.call( entry )

    datafiles << entry.name
  end

  line = "#{datafiles.size} datafiles:\n"
  sum_buf << line



  datafile_count = pack.match_count


  pack.each_match_with_index do |entry,i|
    puts entry.name

    ## filter/select datafiles
    next  unless filter.call( entry )

    line = "[#{i+1}/#{datafiles.size}] >#{entry.name}<\n"
    buf << line; sum_buf << line

    secs = SportDb::LeagueOutlineReader.parse( entry.read )

    if secs.size == 0
      line = "  !!! ERROR !!! - NO sections found; 0 sections\n"
      buf << line;  sum_buf << line
      next
    end


      line = "  #{secs.size} section(s):\n"
      buf << line; sum_buf << line

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
            warns = []
            team_rec = find_club_by( name:    name,
                                     country: country,
                                     mapping: mapping,
                                     warns:   warns )

            if warns.size > 0
              line = warns.join("\n")+"\n"
              buf << line; sum_buf << line

              errors << "#{entry.name}[#{j+1}] - #{warns.join('; ')}"
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


def build_mapping( mapping )
  mapping.reduce({}) do |h,(club_names, club_line)|

    values = club_line.split( ',' )
    values = values.map { |value| value.strip }  ## strip all spaces

    ## todo/fix: make sure country is present !!!!
    club_name, country_name = values
    club = CLUBS.find_by!( name: club_name, country: country_name )

    values = club_names.split( '|' )
    values = values.map { |value| value.strip }  ## strip all spaces

    values.each do |club_name|
      h[club_name] = club
    end
    h
  end
end


mapping_cl = build_mapping({
'Arsenal   | Arsenal FC'    => 'Arsenal, ENG',
'Liverpool | Liverpool FC'  => 'Liverpool, ENG',
'Barcelona'                 => 'Barcelona, ESP',
'Valencia'                  => 'Valencia, ESP'
})



path = cl
buf, errors = read_conf( path, lang: 'en', mapping: mapping_cl,
                                   exclude: ->(datafile) { datafile =~ /archive/ } )

# path = euro
# buf, errors = read_conf( path, lang: 'en' )

# path = world
# buf, errors = read_conf( path, lang: 'en' )

puts buf

if errors.size > 0
  puts "#{errors.size} errors / warns:"
  errors.each do |error|
    puts "!! error: #{error}"
  end
end

puts "bye"



## save
# File.open( "#{path}/.build/conf.txt", 'w:utf-8' ) do |f|
# f.write( buf )
# end
