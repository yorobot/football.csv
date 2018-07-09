# encoding: utf-8

module SportDb
  module Import

def self.data_dir
  ## fix/todo: use SportDb::Import.root plus /config
  File.expand_path( "#{File.dirname(File.dirname(__FILE__))}/config" )
end



class Configuration

  attr_accessor :team_mappings
  attr_accessor :teams


  def initialize

    ## unify team names; team (builtin/known/shared) name mappings
    ## cleanup team names - use local ("native") name with umlaut etc.
    recs = []
    %w(de fr es it pt nl be tr).each do |country|
       txt = File.open( "#{SportDb::Import.data_dir}/teams/#{country}.txt", 'r:utf-8' ).read
       recs += parse_teams_txt( txt )
    end

    ############################
    ## add team mappings
    ##   alt names to canonical pretty (recommended unique) name
    @team_mappings = {}

    recs.each do |rec|
       rec.alt_names.each do |alt_name|
         ## todo/fix: warn about duplicates (if key exits) ???????
         @team_mappings[ alt_name ] = rec.name
       end
    end

###
## reverse hash for lookup/list of "official / registered(?)"
##    pretty recommended canonical unique (long form)
##    team names

    @teams = {}
    recs.each do |rec|
      @teams[ rec.name ] = rec
    end

    self  ## return self for chaining
  end



private

def parse_teams_txt( txt )
  recs = []
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

    ## todo: add country (code) too!!!
    rec = SportDb::Struct::Team.create(
                                    name:      team[0],
                                    city:      team[1],    ## note: team_city is optional for now (might be nil!!!)
                                    alt_names: names
                                  )
    ## pp rec
    recs << rec
  end
  recs
end

end # class Configuration




## lets you use
##   SportDb::Import.configure do |config|
##      config.hello = 'World'
##   end

def self.configure
  yield( config )
end

def self.config
  @config ||= Configuration.new
end

end   # module Import
end   # module SportDb
