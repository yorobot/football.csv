# encoding: utf-8


def build_summary_report( repo, path: )

  buf_summary = ""
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
      buf_details << "start: #{start_date.strftime( '%Y-%m-%d' )}"
      buf_details << " (#{start_date.strftime( '%a' )}), "   ## print weekday
      buf_details << "end: #{end_date.strftime( '%Y-%m-%d' )}"
      buf_details << " (#{end_date.strftime( '%a' )})"   ## print weekday
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

      buf_summary << "- [`#{season_file}`](#{season_file}) => "
      buf_summary << "#{team_usage.size} teams / "
      buf_summary << "#{matches.size} matches / "
      buf_summary << "start: #{start_date.strftime( '%Y-%m-%d' )}"
      buf_summary << " (#{start_date.strftime( '%a' )}), "   ## print weekday
      buf_summary << "end: #{end_date.strftime( '%Y-%m-%d' )}"
      buf_summary << " (#{end_date.strftime( '%a' )})"   ## print weekday

      ## check all teams with equal number of matches - if not warn!!
      if team_usage.first[1] != team_usage.last[1]
         buf_summary  << "  **NOTE / WARN:  played match mismatch !!!! check match datafile**"
      end

      buf_summary << "\n"
    end
    buf_details << "\n"
  end

  "# Summary\n\n" + buf_summary + "\n\n" + buf_details
end
