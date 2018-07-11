# encoding: utf-8


class CsvPyramidReport    ## change to CsvTeamsUpDown/Diff/Level/Report - why? why not?


def initialize( pack )
  @pack = pack    # CsvPackage e.g.pack = CsvPackage.new( repo, path: path )
end


def build_summary
  ###
  ## todo - add count for seasons by level !!!!!
  ##   e.g. level 1 - 25 seasons, 2 - 14 seasons, etc.

  ## find all teams and generate a map w/ all teams n some stats
  teams = SportDb::Struct::TeamUsage.new

  ## collect all seasons by level and all seasons of teams by level
  levels = {}


  season_entries = @pack.find_entries_by_season

  ## note: sort season - latest first
  ##  todo/fix: use File.basename() for sort  - allows subdirs e.g. 1980s, archive etc.
  season_entries.sort { |l,r| r[0] <=> l[0] }.each do |season_entry|
    season_dir   = season_entry[0]
    season_files = season_entry[1]    ## .csv (data)files

    season_files.each_with_index do |season_file,i|
      ## note: assume last directory is the season (season folder)
      season = File.basename( File.dirname( season_file ) )   # get eg. 2011-12
      puts "  season=>#{season}<"

      season_file_basename = File.basename( season_file, '.csv' )    ## e.g. 1-bundesliga, 3a-division3-north etc.
      ## assume first char is a letter for the level!!!!
      ##
      level = season_file_basename[0].to_i
      ##  use to_i -why? why not?  -keep level as a string?
      ## check if level 0 - no integer - why? why not?


      ## keep track of level usage
      levels[level] ||= {}
      ## add seasons (allow multiple datafiles per season)
      level_seasons = levels[level][:seasons] ||= Hash.new(0)   ## count no of datafiles
      level_seasons[ season ] += 1

      level_teams   = levels[level][:teams] ||= {}

      matches   = CsvMatchReader.read( @pack.expand_path( season_file ) )

      team_usage_hash = build_team_usage_in_matches_txt( matches )

      team_names = team_usage_hash.keys.sort
      team_names.each do |team_name|
        level_teams[ team_name ] ||= []
        level_teams[ team_name ] << season   unless level_teams[ team_name ].include?( season )
      end
    end
  end


  pp levels


  ##########################
  ## print / analyze

  buf = ''

  level_keys = levels.keys
  buf << "#{level_keys.size} levels: #{level_keys.join(' ')}\n\n"

  ## loop 1) summary
  level_keys.each do |level_key|
    level = levels[level_key]
    season_keys = level[:seasons].keys
    team_keys   = level[:teams].keys
    buf << "level #{level_key}\n"

    buf << "- #{season_keys.size} seasons: "
    ## sort season_keys - why? why not?
    season_keys.sort.reverse.each do |season_key|
      season_count = level[:seasons][season_key]
      buf << "#{season_key} "
      buf << " (#{season_count}) "    if season_count > 1
    end
    buf << "\n"

    buf << "- #{team_keys.size} teams: "
    team_keys.sort.each do |team_key|
      team_seasons = level[:teams][team_key]
      buf << "#{team_key} (#{team_seasons.size}) "
    end
    buf << "\n"

    ## add teams grouped by seasons count e.g.:
    ##  22 seasons:  Madrid, Barcelona
    ##   3 seasons:   Eibar, ...
    teams_by_seasons = {}
    level[:teams].each do |team_key, team_seasons|
      seasons_count = team_seasons.size
      teams_by_seasons[seasons_count] ||= []
      teams_by_seasons[seasons_count] << team_key
    end
    ## sort by key (e.g. seasons_count : integer)
    teams_by_seasons.keys.sort.reverse.each do |seasons_count|
      team_names = teams_by_seasons[seasons_count]
      buf << "  - #{seasons_count} seasons: "
      buf << team_names.sort.join( ', ' )
      buf << "\n"
    end

    buf << "\n\n"
  end

=begin
  ## loop 2) details
  level_keys.each do |level|   ## change level to level_key!!!
    level_hash = levels[level]
    season_keys = level_hash.keys
    buf << "level #{level} - #{season_keys.size} seasons: #{season_keys.join(' ')}"
    buf << "\n\n"
    season_keys.each_with_index do |season,i|    ## change season to season_key!!!
      buf << "season #{season}:\n"

      ## todo: check for gap e.g. warn about missing season year
      last_season = season_keys[i+1]
      if last_season
          buf << "diff #{season} with #{last_season}:\n"

          season_recs      = level_hash[ season ]
          last_season_recs = level_hash[ last_season ]

          ## for now compare only first datafile (assume single datafile)
          diff_up   = season_recs[0] - last_season_recs[0]
          diff_down = last_season_recs[0] - season_recs[0]

          buf << "#{season_recs[0].size} teams: #{season_recs[0].join(', ')}\n"
          buf << "  - (++) new in season - up (#{diff_up.size}): #{diff_up.join(', ')}\n"
          buf << "  - (--) down (#{diff_down.size}): #{diff_down.join(', ')}\n"
      end
    end
  end
=end

  buf
end # method build_summary


def save( path )
  File.open( path, 'w:utf-8' ) do |f|
    f.write build_summary
  end
end

end # class CsvPyramidReport
