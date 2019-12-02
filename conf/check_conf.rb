require 'sportdb/readers'



OPENFOOTBALL_PATH = '../../../openfootball'

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{OPENFOOTBALL_PATH}/clubs"
SportDb::Import.config.leagues_dir = "#{OPENFOOTBALL_PATH}/leagues"




MATCH_RE = %r{ /\d{4}-\d{2}        ## season folder e.g. /2019-20
                   /[a-z0-9_-]+\.txt$  ## txt e.g /1-premierleague.txt
                }x



def parse( lines )
  start = Date.new( Date.today.year, 7, 1 )   ## fix: use a better date heuristic / guesser
  parser = SportDb::AutoConfParser.new( lines, start )
  parser.parse
end


def read_conf( path, lang: )

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

        clubs_sorted.each do |rec|
          club_name, count = rec
          line = "        "
          line << "#{club_name}"
          line << " x#{count}"     if count > 1
          line << "\n"
          buf << line
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

buf = read_conf( eng, lang: 'en' )
puts buf
