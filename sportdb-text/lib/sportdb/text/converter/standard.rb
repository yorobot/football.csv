# encoding: utf-8


##  add to SportDb / Converter module / namespace - why? why not?


class StandardNews



SPIELTAG_REGEX = /
                    (?<=\s|^)     # use zero assertion lookbehind
                    Spieltag \s (?<round>\d{1,2})
                    (?=\s|$)      # use zero assertion lookahead
                 /xi

DATE_REGEX = /
                (?<=\s|^)     # use zero assertion lookbehind
                   (?<day>\d{2})
                     \.
                   (?<month>\d{2})
                     \.
                   (?<year>\d{4})
              (?=[\s,]|$)      # use zero assertion lookahead
             /xi



def self.read( path, teams:, debug: false )
  txt = File.open( path, 'r:utf-8' ).read

  if debug
    ## e.g. convert
    ##    txt/at1_2018-19.txt     => to
    ##    txt/o/at1_2018-19.debug.txt
    debugpath = "#{File.dirname(path)}/o/#{File.basename(path,'.*')}.debug.txt"
  else
    debugpath = nil
  end

  parse( txt, teams: teams, debug: debug, debugpath: debugpath )
end



def self.parse( txt, teams:, debug: false, debugpath: nil )

  ## split teams into an array
  ## todo/fix: move to a helper for (re)use
  team_names = []
  teams.each_line do |line|
    line = line.strip
    next if line.empty?             ## skip
    next if line.start_with?( '#')  ## skip comments too

    team_names << line
  end
  pp team_names


team_pattern = team_names.map do |team|
  ## escape space to \s
  ## escape dot (.) to \. (literal)
  ## escape () to \( and \)
  team_esc = team.gsub(' ', '\s').
                  gsub('.', '\.').
                  gsub('(', '\(').
                  gsub(')', '\)')

  "(?:#{team_esc})"
end.join('|')

pp team_pattern


team_regex = /
                (?<=\s|^)     # use zero assertion lookbehind
                (?<team>#{team_pattern})
                (?=\s|$)      # use zero assertion lookahead
             /xi


new_lines = []


i=0
last_round = nil
last_date  = nil
matches = []


txt.each_line do |line|
  i+=1

  line = line.strip

  puts "#{i}: >#{line}<"


  ## check spieltag
  if line =~ SPIELTAG_REGEX
    m = $~   # last regex match
    ## puts "** bingo - round #{m[:round]}"
    last_round = m[:round]

    line = line.sub( m[0], '«SPIELTAG»')
  else
    if line =~ DATE_REGEX
      m = $~   # last regex match
      ## puts "** bingo - date #{m[:year]}/#{m[:month]}/#{m[:day]}"
      last_date = "#{m[:year]}-#{m[:month]}-#{m[:day]}"

      line = line.sub( m[0], '«DATE»')

      team1 = nil
      team2 = nil

      if line =~ team_regex
        m = $~   # last regex match
        ## puts "** bingo - team1 #{m[:team]}"
        line = line.sub( m[0], '«TEAM1»')
        team1 = m[:team]
      end

      if line =~ team_regex
        m = $~   # last regex match
        ## puts "** bingo - team2 #{m[:team]}"
        line = line.sub( m[0], '«TEAM2»')
        team2 = m[:team]
      end

      if team1 && team2
        ## match = [last_round, last_date, team1, team2]
        match = SportDb::Struct::Match.new(
                   team1: team1,
                   team2: team2,
                   round: last_round.to_i,
                   date:  last_date )

        puts "** bingo - add new match: #{match.inspect}"
        matches << match
      end
    end
  end

  puts "    >#{line}<"

  new_lines << line
end


  if debug
    File.open( debugpath, 'w:utf-8' ) do |out|
      out << new_lines.join( "\n" )
    end
  end


  ## todo/fix: sort by 1) round and 2) date
  pp matches
  matches
end  # method self.read



def self.convert_to_csv( path, outpath, teams:, debug: false )

  matches = read( path, teams: teams, debug: debug )

  CsvMatchWriter.write( outpath, matches )
end # method self.convert_to_csv


end # class Standard news
