require 'sportdb/readers'



OPENFOOTBALL_PATH = '../../../openfootball'

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{OPENFOOTBALL_PATH}/clubs"
SportDb::Import.config.leagues_dir = "#{OPENFOOTBALL_PATH}/leagues"

### "pre-load" leagues & clubs
LEAGUES   = SportDb::Import.config.leagues
CLUBS     = SportDb::Import.config.clubs
COUNTRIES = SportDb::Import.config.countries





MATCH_RE = %r{ /\d{4}-\d{2}        ## season folder e.g. /2019-20
                   /[a-z0-9_-]+\.txt$  ## txt e.g /1-premierleague.txt
                }x



def parse( lines )
  start = Date.new( Date.today.year, 7, 1 )   ## fix: use a better date heuristic / guesser
  parser = SportDb::AutoConfParser.new( lines, start )
  parser.parse
end



def read_conf( path, lang:, country: )

  unless File.directory?( path )   ## check if path exists (AND is a direcotry)
    puts "  dir >#{path}< missing; NOT found"
    exit 1
  end

  DateFormats.lang  = lang
  SportDb.lang.lang = lang

  buf = String.new

  datafiles = Datafile.find( path, MATCH_RE )
  pp datafiles

  line = "#{datafiles.size} datafiles:\n"
  buf << line; puts line


  country =  COUNTRIES[ country ]  ## map to country_rec - fix: in find_by !!!!

  datafiles.each_with_index do |datafile,i|
    path_rel = datafile[path.length+1..-1]
    line = "[#{i+1}/#{datafiles.size}] >#{path_rel}<\n"
    buf << line;  puts line

    txt = File.open( datafile, 'r:utf-8' ).read
    secs = SportDb::LeagueOutlineReader.parse( txt )
    if secs.size == 0
      line = "  !!! WARN !!! - NO sections found; 0 sections\n"
      buf << line;  puts line
    else
      line = "  #{secs.size} section(s):\n"
      buf << line;  puts line

      secs.each do |sec|
        line =  "    #{sec[:lines].size} lines - "
        line << "league: >#{sec[:league].name}< (#{sec[:league].key}), "
        line << "season: >#{sec[:season]}<"
        line << ", stage: >#{sec[:stage]}<"  if sec[:stage]
        line << "\n"
        buf << line; puts line

        clubs, rounds = parse( sec[:lines ])
        line = "      #{clubs.size} clubs:\n"
        buf << line

        ## sort clubs by usage
        clubs_sorted = clubs.to_a.sort do |l,r|
          res =  r[1] <=> l[1]   ## by count
          res =  l[0] <=> r[0]  if res == 0  ## by club name
          res
        end

        club_recs = []

        clubs_sorted.each do |rec|
          club_name, count = rec

          ## try matching club name
          club_rec = CLUBS.find_by( name: club_name, country: country )
          club_recs << club_rec   if club_rec   ## add if match found

          line = "     "
          if club_rec.nil?
             line << "!! "
          else
             line << "   "
          end

          line << "#{club_name}"
          line << " x#{count}"     if count > 1

          if club_rec
            line << " => #{club_rec.name}"
          end

          line << "\n"
          buf << line
        end

        ## check if all club_recs are uniq(ue)
        diff = club_recs.size - club_recs.uniq.size
        if diff > 0
          buf << "!! ERROR: #{diff} duplicate club record(s) found\n\n"
        end

        line = "      #{rounds.size} rounds:\n"
        buf << line

        rounds.each do |round_name, round_hash|
          line = "        "
          line << "#{round_name}"
          line << " x#{round_hash[:count]}"     if round_hash[:count] > 1
          line << ", #{round_hash[:match_count]} matches"
          line << "\n"
          buf << line
        end
      end
    end
  end
  buf
end


at  = "#{OPENFOOTBALL_PATH}/austria"   ## de
fr  = "#{OPENFOOTBALL_PATH}/france"    ## fr
it  = "#{OPENFOOTBALL_PATH}/italy"     ## it
es  = "#{OPENFOOTBALL_PATH}/espana"    ## es

de  = "#{OPENFOOTBALL_PATH}/deutschland"   ## de
eng = "#{OPENFOOTBALL_PATH}/england"   ## en



path = eng
buf = read_conf( path, lang: 'en', country: 'eng' )

# path = de
# buf = read_conf( path, lang: 'de', country: 'de' )

# path = at
# buf = read_conf( path, lang: 'de', country: 'at' )

# path = es
# buf = read_conf( path, lang: 'es', country: 'es' )

puts buf


## save
File.open( "#{path}/.build/conf.txt", 'w:utf-8' ) do |f|
 f.write( buf )
end
