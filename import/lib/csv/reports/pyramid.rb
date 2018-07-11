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
      levels[level][season] ||=[]      ## keep track of level usage

      matches   = CsvMatchReader.read( @pack.expand_path( season_file ) )

      team_usage_hash = build_team_usage_in_matches_txt( matches )

      team_names = team_usage_hash.keys.sort

      levels[level][season] << team_names     ## for now add team_names only - why? why not?
    end
  end


  ## print / analyze

  buf = ''

  level_keys = levels.keys
  buf << "#{level_keys.size} levels: #{level_keys.join(' ')}\n\n"

  ## loop 1) summary
  level_keys.each do |level|
    level_hash = levels[level]
    season_keys = level_hash.keys
    buf << "level #{level} - #{season_keys.size} seasons: #{season_keys.join(' ')}"
    buf << "\n\n"
  end


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

  buf
end # method build_summary


def save( path )
  File.open( path, 'w:utf-8' ) do |f|
    f.write build_summary
  end
end

end # class CsvPyramidReport
