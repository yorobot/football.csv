# encoding: utf-8


module SportDb
module Import


class TeamReader


def self.from_file( path )   ## use - rename to read_file - why? why not?
  txt = File.open( path, 'r:utf-8' ).read
  read( txt )
end


def self.read( txt )   ## rename to parse - why? why not? and use read for file read?
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

    names = names_line.split( /[|,]/ )   # team names - allow comma(,) or pipe(|)
    team  = team_line.split( ',' )   # (canoncial) team name, team_city

    ## remove leading and trailing spaces
    names = names.map { |name| name.strip }
    team  = team.map { |team| team.strip }
    pp names
    pp team

    canonical_name = team[0]
    city           = team[1]

    ## squish (white)spaces e.g. León     › Guanajuato  => León › Guanajuato
    city = city.gsub( /[ \t]+/, ' ' )   if city

    ## note: remove from alt_names if canonical name (mapping 1:1)
    alt_names = names.select {|name| name != canonical_name }

    ## todo: add country (code) too!!!
    rec = SportDb::Struct::Team.create(
                                    name:      canonical_name,
                                    city:      city,     ## note: team_city is optional for now (might be nil!!!)
                                    alt_names: alt_names
                                  )
    ## pp rec
    recs << rec
  end
  recs
end  # method read
end  # class TeamReader


end ## module Import
end ## module SportDb
