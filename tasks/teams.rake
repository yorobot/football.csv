# encoding: utf-8


task :deteams do |t|
  find_teams_repo( 'de-deutschland' )
end # task :entables

task :engteams do |t|
  find_teams_repo( 'en-england' )
end # task :entables


def find_teams_repo( repo )

  ##
  ## fix: see new build_teams_report !!!


   ##########
   ## add teams.csv
   out_path = "#{out_root}/teams.csv"
   puts "out_path=>>#{out_path}<<"

   ## make sure parent folders exist
   FileUtils.mkdir_p( out_root )  unless Dir.exists?( out_root )

   File.open( out_path, 'w' ) do |out|
      out.puts "Team"
      teams.to_a.each do |t|
        out.puts t.team
      end
   end

   #########
   # add debug.txt
   #
   ##  fix/todo: find a better name?
   out_path = "#{out_root}/debug.txt"

   File.open( out_path, 'w' ) do |out|
      out.puts "## Team Usage Stats"
      out.puts ''
      ary = teams.to_a
      out.puts "  #{ary.size} teams:"
      ary.each_with_index do |t,j|
        out.print '  %5s  '   % "[#{j+1}]"
        out.print '%-28s  '   % t.team
        out.print ':: %4d matches in ' % t.matches
        out.print '%3d files' % t.seasons
        out.print "\n"
      end
   end


end # method find_teams_repo
