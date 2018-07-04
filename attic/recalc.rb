def recalc_repo( repo )
   ## (re)calc standings tables and generate README.md
   ##   repo = 'en-england'

   in_root  = "../#{repo}"
   ## out_root = "./o/#{repo}"
   out_root =  in_root   # write in repo directly!!!

   i=0
   ### assume /1998-99/ dir folder format
   Dir.glob( "#{in_root}/**/[0-9][0-9][0-9][0-9]-[0-9][0-9]" ).each do |in_path_season|
     i+=1

     ### next if i > 2   # for testing only process some folders

     puts "season folder: #{in_path_season}"

     buf = ""

     ## note: assume 1-,2- etc. gets us back sorted leagues
     ##  - use sort. (will not sort by default)
     Dir.glob( "#{in_path_season}/*.csv").sort.each do |in_path_csv|
       puts "   csv: #{in_path_csv}"

       matches   = load_matches( in_path_csv )
       standings = Standings.new
       standings.update( matches )
       ## pp standings.to_a

       ## add standings table in markdown to buffer (buf)

## simple table (only totals - no home/away)
##       standings.to_a.each do |l|
##         buf << '%2d. '  % l.rank
##         buf << '%-28s  ' % l.team
##         buf << '%2d '     % l.played
##         buf << '%3d '     % l.won
##         buf << '%3d '     % l.drawn
##         buf << '%3d '     % l.lost
##         buf << '%3d:%-3d ' % [l.goals_for,l.goals_against]
##         buf << '%3d'       % l.pts
##         buf << "\n"
##       end

         buf << "\n"
         buf << "~~~\n"
         buf << "                                        - Home -          - Away -            - Total -\n"
         buf << "                                 Pld   W  D  L   F:A     W  D  L   F:A      F:A   +/-  Pts\n"

       standings.to_a.each do |l|
         buf << '%2d. '  % l.rank
         buf << '%-28s  ' % l.team
         buf << '%2d  '     % l.played

         buf << '%2d '      % l.home_won
         buf << '%2d '      % l.home_drawn
         buf << '%2d '      % l.home_lost
         buf << '%3d:%-3d  ' % [l.home_goals_for,l.home_goals_against]

         buf << '%2d '       % l.away_won
         buf << '%2d '       % l.away_drawn
         buf << '%2d '       % l.away_lost
         buf << '%3d:%-3d  ' % [l.away_goals_for,l.away_goals_against]

         buf << '%3d:%-3d ' % [l.goals_for,l.goals_against]

         goals_diff = l.goals_for-l.goals_against
         if goals_diff > 0
           buf << '%3s  '  %  "+#{goals_diff}"
         elsif goals_diff < 0
           buf << '%3s  '  %  "#{goals_diff}"
         else ## assume 0
           buf << '     '
         end

         buf << '%3d'       % l.pts
         buf << "\n"
       end


       buf << "~~~\n"
       buf << "\n"
       buf << "(Source: `#{File.basename(in_path_csv)}`)\n"
       buf << "\n"
     end

     ###  cut-off in_path_root (e.g. ../en-england) + 1 for /
     segment =  in_path_season[in_root.size+1..-1]

     out_path = "#{out_root}/#{segment}/README.md"
     puts "out_path=>>#{out_path}<<, segment=>>#{segment}<<"

     ## make sure parent folders exist
     FileUtils.mkdir_p( File.dirname(out_path) )  unless Dir.exists?( File.dirname( out_path ))

     File.open( out_path, 'w' ) do |out|
       out.puts "\n\n"
       out.puts "### Standings\n"
       out.puts "\n"
       out.puts buf
       out.puts "\n"
       out.puts "\n"
       out.puts "---\n"
       out.puts "Pld = Matches; W = Matches won; D = Matches drawn; L = Matches lost; F = Goals for; A = Goals against; +/- = Goal differencence; Pts = Points\n"
       out.puts "\n"
     end
   end
end  # method recalc_repo
