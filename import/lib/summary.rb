# encoding: utf-8


def build_summary_report( repo, path: )

  buf_summaries = []   ## use one summary for every level for now
  buf_details = ""


  pack = CsvPackage.new( repo, path: path )

  season_entries = pack.find_entries_by_season
  season_entries.each do |season_entry|
    season_dir   = season_entry[0]
    season_files = season_entry[1]    ## .csv (data)files

    buf_details << "Season [`#{season_dir}`](#{season_dir}):\n\n"

    season_files.each_with_index do |season_file,i|
      buf_details << "- [`#{season_file}`](#{season_file}) (#{i+1}/#{season_files.size}):\n"

      matches   = CsvMatchReader.read( pack.expand_path( season_file ) )
      start_date = Date.strptime( matches[0].date, '%Y-%m-%d' )
      end_date   = Date.strptime( matches[-1].date, '%Y-%m-%d' )

     ## todo: add total goals e.g.  187 goals or something!!!!

      buf_details << "  - #{matches.size} matches - "
      buf_details << "start: #{start_date.strftime( '%a %b/%-d %Y' )}, "
      buf_details << "end: #{end_date.strftime( '%a %b/%-d %Y' )}"
      buf_details << "\n"


      team_usage_hash = build_team_usage_in_matches_txt( matches )
      team_usage = team_usage_hash.to_a
      ## sort by matches_played and than by team_name !!!!
      team_usage = team_usage.sort do |l,r|
         res = r[1] <=> l[1]     ## note: reverse order - bigger number first e.g. 30 > 28 etc.
         res = l[0] <=> r[0]  if res == 0
         res
      end

      buf_details << "  - #{team_usage.size} teams: "
      team_usage.each do |rec|
        team_name      = rec[0]
        matches_played = rec[1]
        buf_details << "#{team_name} (#{matches_played}) "
      end
      buf_details << "\n"

      ## todo: add total goals e.g.  187 goals or something!!!!


      ## todo/fix:
      ##   use level (e.g. 1-bundesliga)
      #    from file instead of loop index for summary index - why? why not?
      #     will handle missing leagues in hierachy
      #     or handles 3a,3b !!!!! etc.  (see england)

      buf_summaries[i] ||= ''    ## init summary if first time
      buf_summary = buf_summaries[i]

      buf_summary << "- [`#{season_file}`](#{season_file}) => "
      buf_summary << "#{team_usage.size} teams / "
      buf_summary << "#{matches.size} matches / "
      buf_summary << "start: #{start_date.strftime( '%a %b/%-d %Y' )}, "
      buf_summary << "end: #{end_date.strftime( '%a %b/%-d %Y' )}"

      ## check all teams with equal number of matches - if not warn!!
      if team_usage.first[1] != team_usage.last[1]
         buf_summary  << "  **NOTE / WARN:  played match mismatch !!!! check match datafile**"
      end

      buf_summary << "\n"
    end
    buf_details << "\n"
  end

  "# Summary\n\n" + buf_summaries.join( "\n<!-- break -->\n" ) + "\n\n" + buf_details
end



def build_teams_report( repo, path: )

  ## find all teams and generate a map w/ all teams n some stats
  teams = SportDb::Struct::TeamUsage.new


  pack = CsvPackage.new( repo, path: path )

  season_entries = pack.find_entries_by_season
  season_entries.each do |season_entry|
    season_dir   = season_entry[0]
    season_files = season_entry[1]    ## .csv (data)files

    season_files.each_with_index do |season_file,i|
      ## note: assume last directory is the season (season folder)
      season = File.basename( File.dirname( season_file ) )   # get eg. 2011-12
      puts "  season=>#{season}<"

      matches   = CsvMatchReader.read( pack.expand_path( season_file ) )

      teams.update( matches, season: season )
    end
  end

  buf = ''
  buf << "## Team Usage Stats\n\n"

  ary = teams.to_a

  buf << "```\n"
  buf << "  #{ary.size} teams:\n"

  ary.each_with_index do |t,j|
    buf << ('  %5s  '   % "[#{j+1}]")
    buf << ('%-28s  '   % t.team)
    buf << (':: %4d matches in ' % t.matches)
    buf << ('%3d seasons' % t.seasons)
    buf << "\n"
  end
  buf << "```\n"

  buf
end # method build_teams_report
