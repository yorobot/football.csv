# encoding: utf-8


class CsvTeamsReport    ## change to CsvPackageTeamsReport - why? why not?


def initialize( pack )
  @pack = pack    # CsvPackage e.g.pack = CsvPackage.new( repo, path: path )
end


def build_summary
  ###
  ## todo - add count for seasons by level !!!!!
  ##   e.g. level 1 - 25 seasons, 2 - 14 seasons, etc.

  ## find all teams and generate a map w/ all teams n some stats
  teams = SportDb::Struct::TeamUsage.new
  levels = Hash.new(0)   ## keep a counter of levels usage (more than one level?)

  season_entries = @pack.find_entries_by_season
  season_entries.each do |season_entry|
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

      levels[level] += 1   ## keep track of level usage

      matches   = CsvMatchReader.read( @pack.expand_path( season_file ) )

      teams.update( matches, season: season, level: level )
    end
  end



  buf = ''
  buf << "## Teams\n\n"

  ary = teams.to_a

  buf << "```\n"
  buf << "  #{ary.size} teams:\n"

  ary.each_with_index do |t,j|
    buf << ('  %5s  '   % "[#{j+1}]")
    if PRINT_TEAMS[t.team]   ## add marker e.g. (*) for pretty print team name
      team_name_with_marker = "#{t.team}"    ## add (*) - why? why not?
    else
      team_name_with_marker = " x #{t.team} (???)"
    end
    ### todo/fix: add pluralize (match/matches) - check: pluralize method in rails?
    buf << ('%-30s  '   % team_name_with_marker)
    buf << (':: %4d matches in ' % t.matches)
    buf << ('%3d seasons' % t.seasons.size)

    ## note: only add levels breakdown if levels.size greater (>1)
    ##  note: use "global" levels tracker
    if levels.size > 1

      buf << " / #{t.levels.size} levels - "
      ## note: format levels in aligned blocks (10-chars wide)
      levels.each do |level_key,_|
         level = t.levels[ level_key ]
         if level
           level_buf = "#{level_key} (#{level.seasons.size})"
           buf << level_buf
           buf << " " * (10-level_buf.length)    ## fill up to 10
         else
           buf << "   x "
           buf << " " * 5
         end
      end
    end

    buf << "\n"
  end
  buf << "```\n"
  buf << "\n\n"


  ## show list of teams without known pretty print name
  ## show details

  names = []
  ary = teams.to_a
  ary.each do |t|
    names << t.team     if PRINT_TEAMS[t.team].nil?
  end
  names = names.sort   ## sort from a-z

  buf << "Unknown / Missing / ??? (#{names.size}):\n\n"
  buf << "#{names.join(', ')}\n"
  buf << "\n\n"


  ## for easy update add cut-n-paste code snippet
  buf << "```\n"
  names.each do |name|
    buf << ("  %-22s =>\n" % name)
  end
  buf << "```\n\n"



  buf << "### Team Name Mappings\n\n"
  buf << "```\n"

  ary = teams.to_a
  ary.each do |t|
    buf << ('%-26s => ' % t.team)

    ## todo: (auto-)add key to names too - why? why not?
    print_teams = PRINT_TEAMS[t.team]
    if print_teams
       if print_teams.size == 1
         buf << "#{print_teams[0]}"
       else
         ## sort by lenght (smallest first)
         print_teams_sorted = print_teams.sort { |l,r| l.length <=> r.length }
         buf << "(#{print_teams.size}) #{print_teams_sorted.join(' • ')}"
       end
    else
       buf << " x"
    end
    buf << "\n"
  end
  buf << "```\n\n"



  ## show details
  buf << "### Season\n\n"

  ary = teams.to_a
  ary.each do |t|
    buf << "- "
    if PRINT_TEAMS[t.team]   ## add marker e.g. (*) for pretty print team name
      team_name_with_marker = "**#{t.team}**"    ## add (*) - why? why not?
    else
      team_name_with_marker = "x #{t.team} (???)"
    end
    buf << "#{team_name_with_marker} - #{t.seasons.size} #{pluralize('season',t.seasons.size)} in #{t.levels.size} #{pluralize('level',t.levels.size)}\n"
    levels.each do |level_key,_|
       level = t.levels[ level_key ]
       if level
         buf << "  - #{level_key} (#{level.seasons.size}): "
         ## was before pretty print:  buf << level.seasons.sort.reverse.join(' ')
         buf << pretty_print_seasons( level.seasons.sort.reverse )
         buf << "\n"
       end
    end
  end
  buf << "\n"

  buf
end # method build_summary


def save( path )
  File.open( path, 'w:utf-8' ) do |f|
    f.write build_summary
  end
end



#### private helpers
private

def pluralize( noun, counter )
   if counter == 1
     noun
   else
     "#{noun}s"
   end
end


### todo: move to seasons utils or something - why? why not??

def pretty_print_seasons( seasons )
  ## e.g. ['2015-16', '2014-15', '2013-14', '1999-00', '1998-99', '1993-94']
  ##      => 2015-16..2013-14 (3) 1999-00..1998-99 (2) 1993-94
  ##  or
  ##      ['2014-15', '1994-95']
  ##      => 2014-15 1994-95
  ##  or
  ##      ['2017-18', '2016-17', '2015-16', '2014-15', '2013-14', '2012-13', '2011-12', '2010-11', '2009-10', '2008-09', '2006-07', '2005-06', '2004-05', '2003-04']
  ##      => 2017-18..2008-09 (10) 2006-07..2003-04 (4)


  ## step 1: collect seasons in runs
  runs = []
  seasons.each do |season|

    run = runs[-1]  ## get last run (note: returns nil if empty)

    if run.nil?
      ## start new run - very first season / item
      run = []
      run << season
      runs << run
    else
      season_prev = run[-1]  ## get last season from run
      year_prev   = season_prev[0..3].to_i  ## get year

      year = season[0..3].to_i  ## get year (from season) eg. 2015-16 => 2015

      if year == year_prev-1   ## keep adding to run
        run << season
      else ## start new run
        run = []
        run << season
        runs << run
      end
    end
  end

  ## step 2: print runs into buffer (string)
  buf = ''
  runs.each do |run|
     if run.size == 1
        buf << "#{run[0]} "
     else
        ## use first and last season
        buf << "#{run[0]}..#{run[-1]} (#{run.size}) "
     end
  end
  buf = buf.strip   # remove trainling space(s)
  buf
end


end # class CsvTeamsReport
