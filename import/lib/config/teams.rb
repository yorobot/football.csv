# encoding: utf-8


## unify team names; team (builtin/known/shared) name mappings


## todo: check if defined?
##    if defined use merge hash - why? why not?


## used by CsvMatchReader

## cleanup team names - use local ("native") name with umlaut etc.



def teams_txt_to_h( txt )
  h = {}
  txt.each_line do |line|
    line = line.strip

    next if line.empty?
    next if line.start_with?( '#' )   ## skip comments too

    ## strip inline comments too
    ##  e.g Eupen        => KAS Eupen,    ## [de]
    ##   => Eupen        => KAS Eupen,
    line = line.sub( /#.*/, '' ).strip

    pp line
    names_line, team_line = line.split( '=>' )

    names = names_line.split( ',' )   # team names
    team  = team_line.split( ',' )   # (canoncial) team name, team_city

    ## remove leading and trailing spaces
    names = names.map { |name| name.strip }
    team  = team.map { |team| team.strip }
    pp names
    pp team


    canonical_team_name = team[0]
    team_city           = team[1]    ## note: team_city is optional for now (might be nil!!!)

    names.each do |name|
      ## todo/fix: warn about duplicates ???????
      h[name] = canonical_team_name
    end
  end
  h
end


module SportDb
  module Import

   def self.data_dir
      "#{File.expand_path( File.dirname(__FILE__))}"
   end


TEAMS_DE = File.open( "#{data_dir}/teams_de.txt", 'r:utf-8' ).read
TEAMS_FR = File.open( "#{data_dir}/teams_fr.txt", 'r:utf-8' ).read
TEAMS_ES = File.open( "#{data_dir}/teams_de.txt", 'r:utf-8' ).read
TEAMS_IT = File.open( "#{data_dir}/teams_it.txt", 'r:utf-8' ).read
TEAMS_PT = File.open( "#{data_dir}/teams_pt.txt", 'r:utf-8' ).read
TEAMS_NL = File.open( "#{data_dir}/teams_nl.txt", 'r:utf-8' ).read
TEAMS_BE = File.open( "#{data_dir}/teams_be.txt", 'r:utf-8' ).read
TEAMS_TR = File.open( "#{data_dir}/teams_tr.txt", 'r:utf-8' ).read

##
##  todo/fix: change to TEAM_MAPPINGS  - why? why not?

## merge all hashes into one (TEAMS hash)
##   e.g. TEAMS = {}.merge( TEAMS_DE ).merge( TEAMS_TR )
TEAMS = [
         TEAMS_DE,
         TEAMS_FR,
         TEAMS_ES,
         TEAMS_IT,
         TEAMS_PT,
         TEAMS_NL,
         TEAMS_BE,
         TEAMS_TR
       ].reduce( {} ) { |memo,txt| memo.merge( teams_txt_to_h( txt )) }



###
## reverse hash for lookup/list of "official / registered(?)"
##    pretty  recommended unique (long form)
##    team names

# like invert but not lossy
# {"one"=>1,"two"=>2, "1"=>1, "2"=>2}.inverse => {1=>["one", "1"], 2=>["two", "2"]}
PRINT_TEAMS = TEAMS.each_with_object({}) do |(key,value),out|
  out[value] ||= []
  out[value] << key
end


end   # module Import
end   # module SportDb
