# encoding: utf-8


## libs / gems
require 'sportdb/text'     ## csv (text) support
require 'unicode/name'


## our own code
require_relative 'clubs_alphabet'




module TeamIndexer


class TeamIndexDuplicatePart

def initialize( teams )
  @teams = teams
end

def build   ## todo/check: always use render as name - why? why not?

  index = SportDb::Import::ClubIndex.new
  index.add( @teams )

  buf = String.new

  index.mappings.each do |name, clubs|
    if clubs.size > 1
      buf << "- **#{clubs.size}** matching clubs for **`#{name}`**:\n"
      clubs.each do |club|
        buf << "  - #{club.name}, #{club.city}, #{club.country.name} (#{club.country.key})\n"
      end
    end
  end

  ## dump / add recorded errors too
  # if index.errors?
  #   buf << "\n\n"
  #   buf << "**#{index.errors.size} error(s)**:\n"
  #   index.errors.each do |error|
  #     buf << "- #{error}\n"
  #   end
  # end

  buf << "\n\n"
  buf
end # method build

alias_method :render, :build

end # class TeamIndexDuplicatePart



class TeamDuplicateByCountryPart

def initialize( teams )
  @teams = teams
end


def build   ## todo/check: always use render as name - why? why not?

  teams_by_country = @teams.group_by {|team| team.country.key }

  buf = String.new

  teams_by_country.each do |country_key, teams|
    country = SportDb::Import.config.countries[ country_key ]
    buf << "**#{country.name} (#{country.key})**"
    buf << "\n\n"

    buf << TeamDuplicatePart.new( teams ).build
    buf << "\n\n"
  end

  buf << "\n\n"
  buf
end  # method build

alias_method :render, :build

end # class TeamDuplicateByCountryPart


class TeamDuplicatePart

def initialize( teams )
  @teams = teams
end


def build   ## todo/check: always use render as name - why? why not?

  buf = String.new

  @teams.each do |team|
    if team.duplicates?
      duplicates = team.duplicates

      buf << "- **#{team.name}**, #{team.city} (#{duplicates.size}):\n"
      duplicates.each do |norm,names|
        buf << "  - `#{norm}` (#{names.size}):"
        if names.uniq.size > 1
           buf << " #{names.join( ' · ' )}"
        else  ## assume same literal NOT just the norm(alized) names
           names_marked = names.map {|name| "**#{name}**" }
           buf << " #{names_marked.join( ' · ' )}"
        end
        buf << "\n"
      end
    end
  end

  buf << "\n\n"
  buf
end  # method build

alias_method :render, :build

end # class TeamDuplicatePart



class TeamMappingsPart

def initialize( teams )
  @teams = teams
end

def build   ## todo/check: always use render as name - why? why not?
  buf = ''
  buf << "#{@teams.size} clubs"
  buf << "\n\n"

  @teams.each do |team|
       alt_team_names =  team.alt_names

       buf << "- "
       if team.wikipedia?
         ## use wikipedia link
         buf << "[**#{team.name}**](#{team.wikipedia_url})"
       else
         buf << "**#{team.name}**"
       end

       if alt_team_names.nil?
         ## do (print) nothing
       elsif alt_team_names.size == 1
         buf << " : (1) #{alt_team_names[0]}"
       elsif alt_team_names.size > 1
         ## sort by length (smallest first)
         alt_team_names_sorted = alt_team_names.sort { |l,r| l.length <=> r.length }
         buf << " : (#{alt_team_names.size}) #{alt_team_names_sorted.join(' · ')}"
       else
         ## canonical name is mapping name - do not repeat/print for now
       end

       alt_team_names_auto = team.alt_names_auto
       if alt_team_names_auto.nil?
         ## do (print) nothing
       elsif alt_team_names_auto.size == 1
         ## note: add auto-generated name marker e.g. 1† 2† etc.
         buf << " ⇒ (1) ≈#{alt_team_names_auto[0]}≈"
       elsif alt_team_names_auto.size > 1
         ## sort by length (smallest first)
         alt_team_names_auto_sorted = alt_team_names_auto.sort { |l,r| l.length <=> r.length }
         alt_team_names_auto_marked = alt_team_names_auto_sorted.map { |name| "≈#{name}≈" }
         buf << " ⇒ (#{alt_team_names_auto.size}) #{alt_team_names_auto_marked.join(' · ')}"
       else
         # print / do nothing
       end
    buf << "\n"
  end
  buf << "\n\n"

  buf
end  # method build

alias_method :render, :build


end # class TeamMappingsPart


class TeamAtozPart

def initialize( teams )
  @teams = teams
end

def build   ## todo/check: always use render as name - why? why not?
  names = {}   ## count name usage

  @teams.each do |team|
    names[ team.name ] ||= []
    names[ team.name ] << team

    if team.alt_names
      team.alt_names.each do |team_alt_name|

        if team_alt_name.strip == ""     ## use .empty? why? why not?
          puts "empty alt name >#{team_alt_name}<; please fix - sorry:"
          pp team
          exit 1
          ## next
        end
        names[ team_alt_name ] ||= []
        names[ team_alt_name ] << team
      end
    end
  end


  alphas = {}
  names.each do |name, teams|
    ## todo - mark/check name if canoncial (print bold or something - why? why not?)
    alphas[ name[0] ] ||= []
    alphas[ name[0] ] <<  [name, teams]
  end


  buf = ''

  ## pp alphas
  sorted_alphas = alphas.to_a.sort do |l,r|
     res = l[0] <=> r[0]
     res
  end


  sorted_alphas.each do |alpha_rec|
    alpha     = alpha_rec[0]
    name_recs = alpha_rec[1]

    sorted_name_recs = name_recs.sort do |l,r|
      res = l[0].length <=> r[0].length       ## sort by length (smallest first)
      res = l[0] <=> r[0]       if res == 0   ## sort by a-z next
      res
    end


    buf << "- **#{alpha}**"
    buf << " (#{name_recs.size})"
    buf << ": "

    names = sorted_name_recs.map do |name_rec|
      name  = name_rec[0]
      teams = name_rec[1]
      if teams.size > 1
        "!! **#{name} (#{teams.size})** !!"
      else
        name
      end
    end

    buf << "#{names.join(' · ')}"
    buf << "\n"
  end

  buf << "\n\n"
  buf
end  # method build

alias_method :render, :build

end # class TeamAtozPart



class TeamsByCityPart

def initialize( teams )
  @teams = teams
end

def build     ## todo/check: always use render as name - why? why not?
  cities        = {}

  @teams.each do |team|
    ##  note: add geo tree
    team_city =  if team.city
                    if team.geos
                      "#{team.city}, #{team.geos.join(' › ')}"
                    else
                      team.city
                    end
                 else
                   '?'    ## convert nil to '?'
                 end
    cities[team_city] ||= []
    cities[team_city] << team
  end


  buf = ''

  ## sort cities by name
  ##   todo/fix: exlude special key x and ? - why? why not?
  sorted_cities = cities.to_a.sort do |l,r|
     ## note: let '?' always go last in sort order
     res =  0
     res =  1    if l[0] == '?'
     res = -1    if r[0] == '?'  if res == 0

     res = r[1].size <=> l[1].size  if res == 0   ## sort by team size/counter first
     res = l[0] <=> r[0]            if res == 0   ## sort by city name next
     res
  end


  sorted_cities.each do |city_rec|
    city  = city_rec[0]  # city name/key
    teams = city_rec[1]  # teams for city

      if city == '?'
        buf << "- #{city}"
      else
        buf << "- **#{city}**"
      end

      buf << " (#{teams.size})"
      buf << ": "

      if teams.size == 1
        t = teams[0]
        buf << "#{t.name} "
        if t.alt_names && t.alt_names.size > 0
            ##  todo/fix:
            ##    add check for matching city name !!!!
            ##     sort by smallest first - why? why not?
            buf << " (#{t.alt_names.size}) #{t.alt_names.join(' · ')}"
        end
        buf << "\n"
      else
        ## buf << v.map { |t| t.name }.join( ', ')  ## print all canonical team names
        buf << "\n"
        teams.each do |t|
          ## note: markdown needs to escape leading number with backslash!!
          ##            e.g. 1. => 1\.   - escape list marker
          buf << "  - #{escape_list_marker(t.name)} "

          if t.alt_names && t.alt_names.size > 0
            ##  todo/fix:
            ##    add check for matching city name !!!!
            ##     sort by smallest first - why? why not?
            buf << " (#{t.alt_names.size}) #{t.alt_names.join(' · ')}"
          end
          buf << "\n"
        end
      end
  end

  buf << "\n\n"
  buf
end  # method build

private
## private helper to escape list item text if starting with 1. or something
def escape_list_marker( text )
  ## escape numbered list marker
  ##     e.g. 1. => 1\.
  text.sub( /^([0-9]{1,})\./ ) do |_|
    "#{$1}\\."
  end
end

alias_method :render, :build

end  # class TeamsByCityPart


class TeamsByGeoPart

def initialize( teams )
  @teams = teams
end

def build     ## todo/check: always use render as name - why? why not?
  geos = {}

  ## todo/fix: report all teams with missing geo tree? why? why not?
  ##   report just number of missing teams or enumarate all teams with missing geo tree?

  @teams.each do |team|
    if team.city
      if team.geos
        ## cut-off city and keep the rest (of geo tree)
        team_geos = team.geos.join( ' › ' )

        geos[ team_geos ] ||= []
        geos[ team_geos ] << team
      else
        ## use city name / assume city is also admin e.g. Berlin == Berlin › Berlin
        ##  note: mark cities with dagger symbol (†) for now
        team_city = "#{team.city}†"
        geos[ team_city ] ||= []
        geos[ team_city ] << team
      end
    end
  end


  buf = ''

  geos.each do |geo, teams|
      buf << "- **#{geo}**"
      buf << " (#{teams.size})"
      buf << ": "

      team_names = teams.map { |team| team.name }
      buf << "  #{team_names.join(' · ')}"
      buf << "\n"
  end

  buf << "\n\n"
  buf
end  # method build

alias_method :render, :build

end  # class TeamsByGeoPart




class TeamsByYearPart

def initialize( teams )
  @teams = teams
end

def build     ## todo/check: always use render as name - why? why not?
  years = {}             ## by founding year
  historic_years = {}    ## by shutdown / closing year  -- todo: rename historic to __ - why? why not?


   ###
   ## todo/fix: check if name includes (-2011) or (1889-1897) for historic date!!!
   ##   todo/fix: move regex year match to team reader itself!!!

  @teams.each do |team|
    ## note: always use a string as key for now (thus, to_s) - convert nil to ?
    if team.year_end
      team_year_end = team.year_end.to_s
      historic_years[team_year_end] ||= []
      historic_years[team_year_end] << team
    end

    team_year = (team.year || '?').to_s
    years[team_year] ||= []
    years[team_year] << team
  end


  buf = ''

  ## sort years by oldest first (chronologicial)
  ##   todo/fix: exlude special key x and ? - why? why not?
  sorted_years = years.to_a.sort do |l,r|
     res = l[0] <=> r[0]
     res
  end

  buf << build_teams( sorted_years )
  buf << "\n\n"

  if historic_years.size > 0
    sorted_years = historic_years.to_a.sort do |l,r|
       res = l[0] <=> r[0]
       res
    end

    buf << "Historic\n\n"
    buf << build_teams( sorted_years )
    buf << "\n\n"
  end

  buf
end  # method build


private
def build_teams( sorted_years )
  buf = ''
  sorted_years.each do |year_rec|
    year   = year_rec[0]  # year name/key
    teams  = year_rec[1]  # teams for year

      if year == '?'
        buf << "- #{year}"
      else
        buf << "- **#{year}**"
      end

      buf << " (#{teams.size})"
      buf << ": "

      team_names = teams.map { |team| team.name }
      buf << "  #{team_names.join(' · ')}"
      buf << "\n"
  end

  buf << "\n\n"
  buf
end

alias_method :render, :build

end  # class TeamsByYearPart



##
##  todo/fix:  pass in path to cut-off root-path from datafile
##   e.g.  south-america/ar-argentina/clubs.txt
##            becomes   /ar-argentina/clubs.txt
##       or pass in hierarchy (directory) walk(ing) level e.g. 1,2
##                  and cut-off dirs if level greater than 1 (base/start level)
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
     buf << " _(#{teams.size})_:"

     team_names = teams.map do |team|
       if team.wikipedia?
         ## use wikipedia link and markup bold too
         "**[#{team.name}](#{team.wikipedia_url})**"
       else
         team.name
       end
     end
     buf << "  #{team_names.join(' · ')}"
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

   ## pass 1) get all wiki(pedia) page / anchor links for lookup
   wiki = SportDb::Import::WikiIndex.build( path )

   teams = walk_dir( path, root_path: path, level: 1, wiki: wiki )

   ## puts "   process #{teams} datafiles in level 1 >#{path}"
end


## e.g.  /clubs.txt   or
##       /at.clubs.txt, /eng.clubs.txt, etc.

CLUBS_REGEX =  /^(?:
                  clubs\.txt
                    |
                  [a-z]{2,3}\.clubs\.txt
                 )$/x

def walk_dir( path, root_path:, level:, wiki: )

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
       teams_list += walk_dir( entry_path, root_path: root_path, level: level+1, wiki: wiki )
     else
       if CLUBS_REGEX =~ name
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
       teams = SportDb::Import::ClubReader.read( "#{root_path}/#{file}" )

       ## update wiki links for clubs/ teams
       teams.each do |team|
        ## note: wiki find_by does NOT include alt_names_auto !!!
        rec = wiki.find_by( club: team )
        if rec
           ## add wikipedia page
           team.wikipedia = rec.name
         end
       end


       teams_list << [file, teams]

       buf  = TeamIndexer::TeamMappingsPart.new( teams ).build
       buf << "\n\n"
       buf << "Alphabet\n\n"
       buf << TeamIndexer::TeamAlphabetPart.new( teams).build
       buf << "\n\n"
       buf << "Duplicates\n\n"
       buf << TeamIndexer::TeamDuplicatePart.new( teams ).build
       buf << "\n\n"
       buf << "By City\n\n"
       buf << TeamIndexer::TeamsByCityPart.new( teams ).build
       buf << "\n\n"
       buf << "By Region\n\n"
       buf << TeamIndexer::TeamsByGeoPart.new( teams ).build
       buf << "\n\n"
       buf << "By Year\n\n"
       buf << TeamIndexer::TeamsByYearPart.new( teams ).build
       buf << "\n\n"
       buf << "By A to Z\n\n"
       buf << TeamIndexer::TeamAtozPart.new( teams ).build
       buf << "\n\n"

       report_path = "#{root_path}/#{File.dirname(file)}/README.md"
       puts "   !! writing report (teams) to >#{report_path}<..."
       File.open( report_path, 'w:utf-8' ) { |f| f.write buf }
       ## fix: /reports/clubs.rb:460: warning: Unsupported encoding utf8 ignored
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
     File.open( report_path, 'w:utf-8' ) { |f| f.write buf }

     ## add more top-level special reports
     if level == 1
       ## get (join/collect) all teams from all datafiles in a single array
       teams = teams_list.reduce([]) {|teams,item| teams += item[1]; teams }

       buf = String.new
       buf << "Alphabet\n\n"
       buf << TeamIndexer::TeamAlphabetByCountryPart.new( teams ).build
       buf << "\n\n"

       File.open( "#{path}/ALPHABETS.md", 'w:utf-8' ) do |f|
         f.write buf
       end

       buf = String.new
       buf << "Duplicates\n\n"
       buf << TeamIndexer::TeamIndexDuplicatePart.new( teams ).build
       buf << "\n\n"
       buf << "Club Name Duplicates\n\n"
       buf << TeamIndexer::TeamDuplicateByCountryPart.new( teams ).build
       buf << "\n\n"

       File.open( "#{path}/DUPLICATES.md", 'w:utf-8' ) do |f|
         f.write buf
       end
     end
   end

   teams_list
end


walk( '../../openfootball/clubs' )

puts 'ok - bye'
