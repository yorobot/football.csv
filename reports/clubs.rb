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


class TeamsByCityPart

def initialize( teams )
  @teams = teams
end

def build     ## todo/check: always use render as name - why? why not?
  cities        = {}

  @teams.each do |team|
    team_city = team.city || '?'    ## convert nil to ?
    cities[team_city] ||= []
    cities[team_city] << team
  end


  buf = ''

  ## sort cities by name
  ##   todo/fix: exlude special key x and ? - why? why not?
  sorted_cities = cities.to_a.sort do |l,r|
     res = r[1].size <=> l[1].size       ## sort by team size/counter first
     res = l[0] <=> r[0]    if res == 0   ## sort by city name next
     res
  end


  sorted_cities.each do |city_rec|
    city = city_rec[0]  # city name/key
    v    = city_rec[1]  # teams for city

      if city == '?'
        buf << "- #{city}"
      else
        buf << "- **#{city}**"
      end

      buf << " (#{v.size})"
      buf << ": "

      if v.size == 1
        t = v[0]
        buf << "#{t.name} "
        if t.alt_names && t.alt_names.size > 0
            ##  todo/fix:
            ##    add check for matching city name !!!!
            ##     sort by smallest first - why? why not?
            buf << " (#{t.alt_names.size}) #{t.alt_names.join(' • ')}"
        end
        buf << "\n"
      else
        ## buf << v.map { |t| t.name }.join( ', ')  ## print all canonical team names
        buf << "\n"
        v.each do |t|
          buf << "  - #{t.name} "
          if t.alt_names && t.alt_names.size > 0
            ##  todo/fix:
            ##    add check for matching city name !!!!
            ##     sort by smallest first - why? why not?
            buf << " (#{t.alt_names.size}) #{t.alt_names.join(' • ')}"
          end
          buf << "\n"
        end
      end
  end

  buf << "\n\n"
  buf
end  # method build

alias_method :render, :build

end  # class TeamsByCityPart



##
##  todo/fix:  pass in path to cut-off root-path from datafile
##   e.g.  south-america/ar-argentina/clubs.txt
##            becomes   /ar-argentina/clubs.txt
class TeamDatafilePart

def initialize( teams_list )
  @teams_list = teams_list
end

def build   ## todo/check: always use render as name - why? why not?

  teams_count = @teams_list.reduce(0) { |acc,item| acc+item[1].size }

  buf = ''
  buf << "#{@teams_list.size} datafiles, #{teams_count} clubs"
  buf << "\n\n"

  @teams_list.each do |teams_item|
     teams_datafile = teams_item[0]
     teams          = teams_item[1]

     buf << "**#{teams_datafile}**"
     buf << " _(#{teams.size})_"

     team_names = teams.map { |team| team.name }
     buf << "  #{team_names.join(' • ')}"
     buf << "\n\n"
  end

  buf
end  # method build

alias_method :render, :build

end # class TeamDatafilePart
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
   teams_list = []
   entries.each do |name|
     entry_path = "#{path}/#{name}"
     ## note: cut-off in_root (to pretty print path)
     entry_path_rel = entry_path[root_path.length+1..-1]

     if File.directory?( entry_path )
       next  if ['.', '..', '.git'].include?( name )

       puts "   #{level} walking #{entry_path_rel}... "
       teams_list += walk_dir( entry_path, root_path: root_path, level: level+1 )
     else
       if ['clubs.txt'].include?( name )
          files << entry_path_rel
       end
     end
   end

   if files.size > 0
     ## todo/fix: warn if teams > 0
     if teams_list.size > 0
        puts "** WARN - do NOT put clubs.txt in non-terminal nodes / sub folders"
        exit 1
     end
     puts "   process #{files.size} datafiles in level #{level} >#{path}<:"
     pp files

     files.each do |file|
       teams = SportDb::Import::TeamReader.read( "#{root_path}/#{file}" )

       teams_list << [file, teams]

       buf  = TeamIndexer::TeamMappingsPart.new( teams ).build
       buf << "\n\n"
       buf << TeamIndexer::TeamsByCityPart.new( teams ).build


       report_path = "#{root_path}/#{File.dirname(file)}/README.md"
       puts "   !! writing report (teams) to >#{report_path}<..."
       File.open( report_path, 'w:utf8' ) { |f| f.write buf }
     end
   else
     puts "   process summary #{teams_list.size} datafiles in level #{level} >#{path}<:"

     buf = TeamIndexer::TeamDatafilePart.new( teams_list ).build

     report_path =  if level == 1
                      "#{path}/SUMMARY.md"
                    else
                      "#{path}/README.md"
                    end
     puts "   !! writing report (datafiles) to >#{report_path}<..."
     File.open( report_path, 'w:utf8' ) { |f| f.write buf }
   end

   teams_list
end




walk( '../../openfootball/clubs' )

puts 'ok - bye'
