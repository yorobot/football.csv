# encoding: utf-8


class CsvPyramidReport    ## change to CsvTeamsUpDown/Diff/Level/Report - why? why not?


   class TeamLine
     attr_reader :name,
                 :seasons

     def initialize( name )
       @name     = name
       @seasons  = {}    ## seasons by level
     end

     def update( level:, season: )
       ##  use seasons to track datafile count as value - why? why not?
       h = @seasons[ level ] ||= Hash.new(0)
       h[ season ] += 1
     end
   end   # class TeamLine

   class SeasonLine
     attr_reader :name,
                 :datafiles

     def initialize( name )
       @name       = name
       @datafiles  = {}    ## datafiles by level
     end

     def update( level:, datafile: )
       ##  use seasons to track datafile count as value - why? why not?
       recs = @datafiles[ level ] ||= []
       recs << datafile
     end
   end   # class SeasonLine


   class LevelLine
     ## attr_reader :name, :seasons, :teams

     def initialize( name )
       @name     = name
       @seasons  = Hash.new(0)  ## count no of datafiles for season
                                ## add seasons (note: allow multiple datafiles per season)
       @teams    = {}   ## count for now all seasons of teams
     end

     def update_season( season )
        @seasons[ season ] += 1
     end

     def update_team( team, season: '?' )
         @teams[ team ] ||= []
         @teams[ team ] << season   unless @teams[ team ].include?( season )
     end


     def build    ## use build_summary (in string buffer for reporting)
       season_keys = @seasons.keys
       team_keys   = @teams.keys

       buf = ''
       buf << "level #{@name}\n"

       buf << "- #{season_keys.size} seasons: "
       ## sort season_keys - why? why not?
       season_keys.sort.reverse.each do |season_key|
         season_count = @seasons[season_key]
         buf << "#{season_key} "
         buf << " (#{season_count}) "    if season_count > 1
       end
       buf << "\n"

       buf << "- #{team_keys.size} teams: "
       team_keys.sort.each do |team_key|
         team_seasons = @teams[team_key]
         buf << "#{team_key} (#{team_seasons.size}) "
       end
       buf << "\n"

       ## add teams grouped by seasons count e.g.:
       ##  22 seasons:  Madrid, Barcelona
       ##   3 seasons:   Eibar, ...
       teams_by_seasons = {}
       @teams.each do |team_key, team_seasons|
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
       buf
     end # method build
   end   # class LevelLine



def initialize( pack )
  @pack = pack    # CsvPackage e.g.pack = CsvPackage.new( repo, path: path )
end


def build_summary

  ###
  ## todo - add count for seasons by level !!!!!
  ##   e.g. level 1 - 25 seasons, 2 - 14 seasons, etc.

   all_teams     = {}   ## holds TeamLine records
   all_seasons   = {}   ## holds SeasonLine records
   all_levels    = {}   ## holds LevelLine records -- collect all seasons by level and all seasons of teams by level
   all_datafiles = {}   ## holds MatchAnalyzer objects - keyed by datafile name/path



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


      ###########################################################
      ## keep track of statistics with "line" records for level, season, team, etc.
      matches   = CsvMatchReader.read( @pack.expand_path( season_file ) )

      matchlist = SportDb::Struct::Matchlist.new( matches )
      all_datafiles[season_file] = matchlist


      level_line = all_levels[ level ] ||= LevelLine.new( level )
      level_line.update_season( season )

      season_line = all_seasons[ season ] ||= SeasonLine.new( season )
      season_line.update( level: level, datafile: season_file )


      matchlist.teams.each do |team|
        team_line = all_teams[ team ] ||= TeamLine.new( team )
        team_line.update( level: level, season: season )

        level_line.update_team( team, season: season )
      end
    end
  end


  pp all_seasons
  pp all_teams
  pp all_levels


  ##########################
  ## print / analyze

  buf = ''

  season_keys   = all_seasons.keys
  level_keys    = all_levels.keys
  team_keys     = all_teams.keys
  datafile_keys = all_datafiles.keys

  buf << "#{season_keys.size} seasons, "
  buf << "#{level_keys.size} levels (#{level_keys.join(' ')}), "
  buf << "#{team_keys.size} teams "
  buf << "in #{datafile_keys.size} datafiles"
  buf << "\n\n"

  ## todo: add no of datafiles  (and no of matches too??)


  ## loop 1) summary
  level_keys.each do |level_key|
    level = all_levels[level_key]
    buf << level.build
  end

  ## loop 2) datafiles
  datafile_keys.each do |datafile_key|
    matchlist = all_datafiles[datafile_key]
    rounds = matchlist.rounds? ? matchlist.rounds : '???'
    buf << "#{datafile_key} - "
    buf << "#{matchlist.teams.size} teams, #{matchlist.matches.size} matches, #{rounds} rounds"
    buf << "\n"
  end
  buf << "\n\n"


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
