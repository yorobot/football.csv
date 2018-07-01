# encoding: utf-8

module SportDb
  module Struct


class TeamUsageLine
  attr_accessor  :team,
                 :matches,  ## number of matches (played),
                 :seasons,  ## number of seasons
                 ## :played1, ## in division 1
                 ## :played2, ## in division 2
                 ## :played3, ## in division 3
                 ## :seasons1,
                 ## :seasons2,
                 ## :seasons3,
                 :last_season  ## cache for last_season seen

  def initialize( team )
    @team = team

    @matches  = 0
    @seasons  = 0
    @last_season = nil  # or use 0 or '' why? why not?
  end
end # class TeamUsageLine




class TeamUsage

  def initialize( opts={} )
    @lines = {}   # StandingsLines cached by team name/key
  end


  def update( matches, season: '?' )
    ## convenience - update all matches at once
    matches.each_with_index do |match,i| # note: index(i) starts w/ zero (0)
      update_match( match, season: season )
    end
    self  # note: return self to allow chaining
  end

  def to_a
    ## return lines; sort

    # build array from hash
    ary = []
    @lines.each do |k,v|
      ary << v
    end

    ## for now sort just by name (a-z)
    ary.sort! do |l,r|
      ## note: reverse order (thus, change l,r to r,l)
      l.team <=> r.team
    end

    ary
  end  # to_a


private
  def update_match( m, season: '?' )   ## add a match

    line1 = @lines[ m.team1 ] || TeamUsageLine.new( m.team1 )
    line2 = @lines[ m.team2 ] || TeamUsageLine.new( m.team2 )

    line1.matches +=1
    line2.matches +=1

    line1.seasons +=1   if season != line1.last_season
    line2.seasons +=1   if season != line2.last_season


    line1.last_season = season
    line2.last_season = season

    @lines[ m.team1 ] = line1
    @lines[ m.team2 ] = line2
  end  # method update_match


end # class TeamUsage

end # module Struct
end # module SportDb
