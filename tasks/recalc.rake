# encoding: utf-8


task :engtables do |t|
  recalc_repo( 'en-england' )
end # task :entables

task :detables do |t|
  recalc_repo( 'de-deutschland' )
end # task :entables



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

     ## for now start/try eng1 league; add more later
     Dir.glob( "#{in_path_season}/1-*.csv").each do |in_path_csv|
       puts "   csv: #{in_path_csv}"
       
       matches   = load_matches( in_path_csv )
       standings = Standings.new
       standings.update( matches )
       ## pp standings.to_a


       ## add standings table in markdown to buffer (buf)
       standings.to_a.each do |l|
         buf << '%2d. '  % l.rank
         buf << '%-28s  ' % l.team
         buf << '%2d '     % l.played
         buf << '%3d '     % l.won
         buf << '%3d '     % l.drawn
         buf << '%3d '     % l.lost
         buf << '%3d:%-3d ' % [l.goals_for,l.goals_against]
         buf << '%3d'       % l.pts
         buf << "\n"
       end

       buf << "\n"
       buf << "(Source: #{File.basename(in_path_csv)})"
     end

     ###  cut-off in_path_root (e.g. ../en-england) + 1 for /
     segment =  in_path_season[in_root.size+1..-1]

     out_path = "#{out_root}/#{segment}/README.md"
     puts "out_path=>>#{out_path}<<, segment=>>#{segment}<<"

     File.open( out_path, 'w' ) do |out|
       out.puts "\n\n"
       out.puts "### Standings\n\n"
       out.puts "~~~\n"
       out.puts buf
       out.puts "~~~\n"
     end
   end
end  # method recalc_repo

