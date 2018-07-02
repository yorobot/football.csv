# encoding: utf-8


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
  buf << "## Teams\n\n"

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
