# encoding: utf-8


class CsvMatchWriter

def self.write( path, matches, format: 'classic' )

  ## for convenience - make sure parent folders/directories exist
  FileUtils.mkdir_p( File.dirname( path) )  unless Dir.exists?( File.dirname( path ))


  out = File.new( path, 'w:utf-8' )

  if format == 'mls'
    out <<  "Stage,Round,Leg,Conf 1,Conf 2,Date,Team 1,FT,HT,Team 2,ET,P\n"  # add headers
  elsif format == 'champs'
    ## add country1 and country2 to team name - why? why not?
    out <<  "Stage,Round,Leg,Group,Date,Team 1,FT,HT,Team 2,ET,P,Country 1,Country 2\n"  # add headers
  else   ## default to classic headers
    out <<  "Round,Date,Team 1,FT,HT,Team 2\n"  # add headers
  end



  ## track match played for team
  played = Hash.new(0)

  matches.each_with_index do |match,i|

    if i < 2
       puts "[#{i}]:" + match.inspect
    end

    values = []

    if ['mls', 'champs'].include?( format )
      values << match.stage
    end

    if match.round     ## optional: might be nil
      values << match.round
    else
      values << "?"   ## match round missing - fix - add!!!!
    end

    if ['mls', 'champs'].include?( format )
      ## note: use - for undefined/nil/not applicable (n/a)
      ##       use ? for unknown
      values << (match.leg ? match.leg : '')
    end


    if format == 'mls'
      values << match.conf1
      values << match.conf2
    end

    if format == 'champs'
      values << (match.group ? match.group : '')
    end


    ## note:
    ##   as a convention add all auto-calculated values in ()
    ##  e.g. weekday e.g. (Fri), weeknumber (22), matches played (2), etc.

    ## for easier double-checking of rounds and dates
    ##  (auto-)add weekday and weeknumber
    ##  todo/fix: weeknumber - use +1  (do NOT start with 0 - why? why not)
    if match.date
      ## note: assumes string for now e.g. 2018-11-22
      date = Date.strptime( match.date, '%Y-%m-%d' )
      values << date.strftime( '(%a) %-d %b %Y (W%-W)' )   ## print weekday e.g. Fri, Sat, etc.
    else
      values << '?'
    end

    team1_played = played[match.team1] += 1
    team2_played = played[match.team2] += 1


    ## note: remove (1991-)  or (-2011) or (1899-1911) from team names for now
    team1 = match.team1.gsub( /\([0-9\- ]+\)/, '' ).strip

    values << "#{team1} (#{team1_played})"

    if match.score1 && match.score2
      values << match.score_str
    else
      # no (or incomplete) full time score; add empty
      values << '?'
    end

    if match.score1i && match.score2i
      values << match.scorei_str
    else
      # no (or incomplete) half time score; add empty
      values << '?'
    end

    ## note: remove (1991-)  or (-2011) or (1899-1911) from team names for now
    team2 = match.team2.gsub( /\([0-9\- ]+\)/, '' ).strip
    values << "#{team2} (#{team2_played})"


    if ['mls', 'champs'].include?( format )
      if match.score1et && match.score2et
        values << "#{match.score1et}-#{match.score2et} (a.e.t.)"
      else
        values << ''
      end

      if match.score1p && match.score2p
        values << "#{match.score1p}-#{match.score2p} (pen.)"
      else
        values << ''
      end
    end

    if format == 'champs'
      values << match.country1
      values << match.country2
    end

    out << values.join( ',' )
    out << "\n"
  end

  out.close
end
end # class CsvMatchWriter
