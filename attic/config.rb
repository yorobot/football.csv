class Configuration

  attr_accessor :team_mappings
  attr_accessor :teams


  def initialize

    ## unify team names; team (builtin/known/shared) name mappings
    ## cleanup team names - use local ("native") name with umlaut etc.
    ##
    ## merge all hashes into one (TEAMS hash)
    ##   e.g. TEAMS = {}.merge( TEAMS_DE ).merge( TEAMS_TR )
    h = {}
    %w(de fr es it pt nl be tr).each do |country|
       txt = File.open( "#{SportDb::Import.data_dir}/teams/#{country}.txt", 'r:utf-8' ).read
       h = h.merge( teams_txt_to_h( txt ) )
    end

    @team_mappings = h

###
## reverse hash for lookup/list of "official / registered(?)"
##    pretty  recommended unique (long form)
##    team names

# like invert but not lossy
# {"one"=>1,"two"=>2, "1"=>1, "2"=>2}.inverse => {1=>["one", "1"], 2=>["two", "2"]}
    @teams = h.each_with_object({}) do |(key,value),out|
       out[value] ||= []
       out[value] << key
    end

    self  ## return self for chaining
  end



private

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

end # class Configuration
