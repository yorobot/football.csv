# encoding: utf-8


require 'sportdb/text'     ## csv (text) support


module TeamIndexer
class TeamMappingsPart

def initialize( teams )
  @teams = teams
end

def build   ## todo/check: always use render as name - why? why not?
  buf = ''
  buf << "#{@teams.size} clubs"
  buf << "\n\n"
  buf << "```\n"

  @teams.each do |team|
       alt_team_names =  team.alt_names

       buf << ('%-26s  ' % team.name)
       if alt_team_names.nil?
         ## do (print) nothing
       elsif alt_team_names.size == 1
         buf << "=> #{alt_team_names[0]}"
       elsif alt_team_names.size > 1
         ## sort by length (smallest first)
         alt_team_names_sorted = alt_team_names.sort { |l,r| l.length <=> r.length }
         buf << "=> (#{alt_team_names.size}) #{alt_team_names_sorted.join(' • ')}"
       else
         ## canonical name is mapping name - do not repeat/print for now
       end
    buf << "\n"
  end
  buf << "```\n\n"

  buf
end  # method build

alias_method :render, :build


end # class TeamMappingsPart
end # module TeamIndexer





def walk( path )
## note: use full package path as root path
   ##  e.g. ./o/be-belgium or something
   root_path = path
   pp root_path

   teams = walk_dir( path, root_path: path, level: 1 )

   ## puts "   process #{teams} datafiles in level 1 >#{path}"
end


def walk_dir( path, root_path:, level: )

   entries = Dir.entries( path )
   ## todo/fix: sort - why? why not?  is already sorted?
   ## pp entries

   files = []
   team_count = 0
   entries.each do |name|
     entry_path = "#{path}/#{name}"
     ## note: cut-off in_root (to pretty print path)
     entry_path_rel = entry_path[root_path.length+1..-1]

     if File.directory?( entry_path )
       next  if ['.', '..', '.git'].include?( name )

       puts "   #{level} walking #{entry_path_rel}... "
       team_count += walk_dir( entry_path, root_path: root_path, level: level+1 )
     else
       if ['clubs.txt'].include?( name )
          files << entry_path_rel
       end
     end
   end

   if files.size > 0
     ## todo/fix: warn if teams > 0
     if team_count > 0
        puts "** WARN - do NOT put clubs.txt in non-terminal nodes / sub folders"
        exit 1
     end
     puts "   process #{files.size} datafiles in level #{level} >#{path}<:"
     pp files

     files.each do |file|
       teams = SportDb::Import::TeamReader.read( "#{root_path}/#{file}" )
       buf = TeamIndexer::TeamMappingsPart.new( teams ).build
       puts buf

       report_path = "#{root_path}/#{File.dirname(file)}/README.md"
       puts "   !! writing report to >#{report_path}<..."
       File.open( report_path, 'w:utf8' ) { |f| f.write buf }
     end
   else
     puts "   process summary #{team_count} datafiles in level #{level} >#{path}<:"
   end

   team_count + files.size   ## return number of club/team datafiles
end




walk( '../../openfootball/clubs' )

puts 'ok - bye'
