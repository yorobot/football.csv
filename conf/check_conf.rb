require 'sportdb/readers'



OPENFOOTBALL_PATH = '../openfootball'



MATCH_RE = %r{ /\d{4}-\d{2}        ## season folder e.g. /2019-20
                   /[a-z0-9_-]+\.txt$  ## txt e.g /1-premierleague.txt
                }x



def parse( lines )
  start = Date.new( Date.today.year, 7, 1 )   ## fix: use a better date heuristic / guesser
  parser = SportDb::AutoConfParser.new( lines, start )
  parser.parse
end


def read_conf( path )
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

        clubs = parse( sec[:lines ])
        line = "      #{clubs.size} clubs:\n"
        buf << line
        clubs.each do |club_name, count|
          line = "        #{club_name} x#{count}\n"
          buf << line
        end
      end
    end
  end
  buf
end


at = "#{OPENFOOTBALL_PATH}/austria"
fr = "#{OPENFOOTBALL_PATH}/france"
it = "#{OPENFOOTBALL_PATH}/italy"
es = "#{OPENFOOTBALL_PATH}/espana"

buf = read_conf( es )
puts buf
