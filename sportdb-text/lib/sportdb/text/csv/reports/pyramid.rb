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
     attr_reader  :seasons, :teams     ## add :name - why? why not?

     def initialize( name )
       @name     = name
       @seasons  = {}   ## count for now all datafiles for season
                        ##   note: allow multiple datafiles per season
       @teams    = {}   ## count for now all seasons of teams
     end

     def update_season( season, datafile: )
        @seasons[ season ] ||= []
        @seasons[ season ] << datafile
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
         datafiles = @seasons[season_key]
         buf << "#{season_key} "
         buf << " (#{datafiles.size}) "    if datafiles.size > 1
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
       canonical_teams = SportDb::Import.config.teams  ## was pretty_print_team_names

       teams_by_seasons.keys.sort.reverse.each do |seasons_count|
         team_names = teams_by_seasons[seasons_count]
         buf << "  - #{seasons_count} seasons: "

         ## markup teams if canonical / known / registered
         team_names = team_names.sort.map do |team_name|
           if canonical_teams[team_name]   ## add marker e.g. (*) for pretty print team name
             "**#{team_name}**"    ## add (*) - why? why not?
           else
             "x #{team_name} (???)"
           end
         end
         buf << team_names.join( ', ' )
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
   all_datafiles = {}   ## holds Matchlist objects - keyed by datafile name/path



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
      level_line.update_season( season, datafile: season_file )

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


=begin
  ## loop 2) datafiles
  datafile_keys.each do |datafile_key|
    matchlist = all_datafiles[datafile_key]
    rounds = matchlist.rounds? ? matchlist.rounds : '???'
    buf << "#{datafile_key} - "
    buf << "#{matchlist.teams.size} teams, #{matchlist.matches.size} matches, #{rounds} rounds"
    buf << "\n"
  end
  buf << "\n\n"
=end


  ## loop 2) datafile summary by level
  level_keys.each do |level_key|
    level = all_levels[level_key]

    season_keys = level.seasons.keys
    buf << "level #{level_key} - #{season_keys.size} seasons:\n"
    ## sort season_keys - why? why not?
    season_keys.sort.reverse.each do |season_key|
      datafiles = level.seasons[season_key]

      if datafiles.size > 1
         buf << "   - todo/fix more than one dafile per season!!!"
      else
         datafile  = datafiles[0]
         matchlist = all_datafiles[ datafile ]  ## work with first datafile only for now

         buf << "- [`#{datafile}`](#{datafile}) => "
         buf << " #{matchlist.teams.size} teams, "
         buf << " #{matchlist.matches.size} matches, "
         buf << " #{matchlist.goals} goals, "
         if matchlist.rounds?
           buf << " #{matchlist.rounds} rounds, "
         else
           buf << " **WARN - unbalanced rounds - fix/double check?!**"
         end
         if matchlist.start_date? && matchlist.end_date?  ## note: start_date/end_date might be optional/missing
           buf << " #{matchlist.start_date.strftime( '%a %d %b %Y' )} - #{matchlist.end_date.strftime( '%a %d %b %Y' )}"
         else
           buf << "**WARN - start: ???, end: ???**"
         end
         buf << "\n"
      end
    end
    buf << "\n\n"
  end


  ## loop 3) season details
  season_keys.each do |season_key|
    prev_season_key = SeasonUtils.prev( season_key )

    season          = all_seasons[season_key]
    prev_season     = all_seasons[prev_season_key]
    ## season holds datafiles (grouped) by level

    buf << "#{season_key} - #{season.datafiles.size} levels (#{season.datafiles.keys.join(' ')})"
    buf << "\n"

    ## todo/fix: rename/change datafiles to level - why? why not?
    season.datafiles.keys.each do |level_key|
      buf << "  - #{level_key}:"
      datafiles = season.datafiles[level_key]
      buf << " [`#{datafiles[0]}`](#{datafiles[0]}) - "

      ## find matchlist by datafile name
      matchlist = all_datafiles[ datafiles[0] ]  ## work with first datafile only for now
      buf << " #{matchlist.teams.size} teams, "
      buf << " #{matchlist.matches.size} matches, "
      buf << " #{matchlist.goals} goals, "
      buf << " #{matchlist.rounds} rounds, "    if matchlist.rounds?
      if matchlist.start_date? && matchlist.end_date?
        buf << " #{matchlist.start_date.strftime( '%a %-d %b %Y' )} - #{matchlist.end_date.strftime( '%a %-d %b %Y' )}"
      else
        buf << " start: ???, end: ???"
      end
      buf << "\n"

      if matchlist.rounds?
        buf << "    - #{matchlist.teams.join(', ')}"
        buf << "\n"
      else
        ## todo/fix: print teams with match played
=begin
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
=end
      end

      ## todo/fix:
      ##    add unknown (missing canonical mapping) teams!!!!

=begin
canonical_teams = SportDb::Import.config.teams  ## was pretty_print_team_names

## find all unmapped/unknown/missing teams
##   with no pretty print team names in league
names = []
team_usage.each do |rec|
  team_name = rec[0]
  names << team_name     if canonical_teams[team_name].nil?
end
names = names.sort   ## sort from a-z

if names.size > 0
  buf_details << "    - #{names.size} teams unknown / missing / ???: "
  buf_details << "#{names.join(', ')}\n"
end
=end


      ## find previous/last season if available for diff
      if prev_season
        prev_datafiles = prev_season.datafiles[level_key]
        if prev_datafiles  ## note: level might be missing in prev season!!
          ## buf << "    - diff #{season_key} <=> #{prev_season_key}:\n"
          prev_matchlist = all_datafiles[ prev_datafiles[0] ]  ## work with first datafile only for now

          diff_plus   = (matchlist.teams - prev_matchlist.teams).sort
          diff_minus  = (prev_matchlist.teams -  matchlist.teams).sort

          buf << "      - (++) new in season #{season_key}: "
          buf << "(#{diff_plus.size}) #{diff_plus.join(', ')}\n"

          buf << "      - (--) out "
          if level_key == 1    ## todo: check level_key is string or int?
            buf << "down: "
          else
            buf << "up/down: "   ## assume up/down for all other levels in pyramid
          end
          buf << "(#{diff_minus.size}) #{diff_minus.join(', ')}\n"
          buf << "\n"
        end
      end
    end
  end
  buf << "\n\n"

  buf
end # method build_summary


def save( path )
  File.open( path, 'w:utf-8' ) do |f|
    f.write build_summary
  end
end


end # class CsvPyramidReport