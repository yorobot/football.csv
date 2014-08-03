# encoding: utf-8

##########
# todo/fix:
##   reuse standings helper/calculator from sportdb
##   do NOT duplicate


class Standings

  def initialize( opts={} )
    ## fix:
    # passing in e.g. pts for win (3? 2? etc.)
    # default to 3 for now

    ## lets you pass in 2 as an alterantive, for example
    @pts_won = opts[:pts_won] || 3

    @lines = {}   # StandingsLines cached by team name/key
  end


  def update( match_or_matches )
    ## convenience - update all matches at once
    if match_or_matches.is_a? Array
      matches = match_or_matches
      matches.each_with_index do |match,i| # note: index(i) starts w/ zero (0)
        update_match( match )
      end
    else
      match = match_or_matches
      update_match( match )
    end
    self  # note: return self to allow chaining
  end

  def to_a
    ## return lines; sort and add rank
    ## note: will update rank!!!! (side effect)

    #############################
    ### calc ranking position (rank)
    ## fix/allow same rank e.g. all 1 or more than one team 3rd etc.

    # build array from hash
    ary = []
    @lines.each do |k,v|
      ary << v
    end

    ary.sort! do |l,r|
      ## note: reverse order (thus, change l,r to r,l)
      value = r.pts <=> l.pts
      if value == 0 # same pts try goal diff
        value = (r.goals_for-r.goals_against) <=> (l.goals_for-l.goals_against)
        if value == 0 # same goal diff too; try assume more goals better for now
          value = r.goals_for <=> l.goals_for
        end
      end
      value
    end

    ## update rank using ordered array
    ary.each_with_index do |line,i|
      line.rank = i+1 ## add ranking (e.g. 1,2,3 etc.) - note: i starts w/ zero (0)
    end
    
    ary
  end  # to_a


private
  def update_match( m )   ## add a match

    ##  puts "   #{m.team1} - #{m.team2} #{m.score_str}"
    unless m.over?
      puts " !!!! skipping match - not yet over (play_at date in the future)"
      return
    end

    unless m.complete?
      puts "!!! [calc_standings] skipping match #{m.team1} - #{m.team2} - scores incomplete #{m.score_str}"
      return
    end

    line1 = @lines[ m.team1 ] || StandingsLine.new( m.team1 )
    line2 = @lines[ m.team2 ] || StandingsLine.new( m.team2 )

    line1.played      += 1
    line1.home_played += 1

    line2.played      += 1
    line2.away_played += 1

    if m.winner == 1
      line1.won      += 1
      line1.home_won += 1

      line2.lost      += 1
      line2.away_lost += 1

      line1.pts      += @pts_won
      line1.home_pts += @pts_won
    elsif m.winner == 2
      line1.lost      += 1
      line1.home_lost += 1

      line2.won       += 1
      line2.away_won  += 1

      line2.pts      += @pts_won
      line2.away_pts += @pts_won
    else ## assume drawn/tie (that is, 0)
      line1.drawn      += 1
      line1.home_drawn += 1

      line2.drawn      += 1
      line2.away_drawn += 1

      line1.pts      += 1
      line1.home_pts += 1
      line2.pts      += 1
      line2.away_pts += 1
    end

    line1.goals_for      += m.score1
    line1.home_goals_for += m.score1
    line1.goals_against      += m.score2
    line1.home_goals_against += m.score2

    line2.goals_for      += m.score2
    line2.away_goals_for += m.score2
    line2.goals_against      += m.score1
    line2.away_goals_against += m.score1

    @lines[ m.team1 ] = line1
    @lines[ m.team2 ] = line2
  end  # method update_match

end  # class Standings


class StandingsLine
  attr_accessor  :rank, :team,
                 :played, :won, :lost, :drawn,                      ## -- total
                 :goals_for, :goals_against, :pts,
                 :home_played, :home_won, :home_lost, :home_drawn,  ## -- home
                 :home_goals_for, :home_goals_against, :home_pts,
                 :away_played, :away_won, :away_lost, :away_drawn,  ## -- away
                 :away_goals_for, :away_goals_against, :away_pts

  def initialize( team )
    @rank = nil # use 0? why? why not?
    @team = team
    @played = @home_played = @away_played = 0
    @won    = @home_won    = @away_won    = 0
    @lost   = @home_lost   = @away_lost   = 0
    @drawn  = @home_drawn  = @away_drawn  = 0
    @goals_for     = @home_goals_for     = @away_goals_for     = 0
    @goals_against = @home_goals_against = @away_goals_against = 0
    @pts    = @home_pts    = @away_pts    = 0
  end
end # class StandingsLine


class Match

  attr_reader :team1,  :team2,
              :score1, :score2,
              :winner    # return 1,2,0   1 => team1, 2 => team2, 0 => draw/tie

  def initialize
    ## do nothing for now (use from_csv to setup data)
  end

  def over?()      true; end  ## for now all matches are over - in the future check date!!!
  def complete?()  true; end  ## for now all scores are complete - in the future check scores; might be missing - not yet entered

  def score_str    # pretty print scores; convenience method
    "#{score1}-#{score2}"
  end


  def from_csv( row )
    @team1 = row[ 'Team 1' ]
    @team2 = row[ 'Team 2' ]

    ft = row[ 'FT' ]
    if ft =~ /^\d{1,2}-\d{1,2}$/   ## sanity check scores format
      scores = ft.split('-')
      @score1 = scores[0].to_i
      @score2 = scores[1].to_i

      ### calculate winner - use 1,2,0
      if @score1 > @score2
        @winner = 1
      elsif @score2 > @score1
        @winner = 2
      elsif @score1 == @score2
        @winner = 0
      else
        ## should never happen
        puts "*** !!! wrong full time scores format; cannot calculate winner >>#{@score1}-#{@score2}<<; exit; sorry"
        exit 1
      end
    else
      puts "*** !!! wrong full time scores format >>#{ft}<<; exit; sorry"
      exit 1
    end
    
    ## note: return self for allowing chaining e.g. matches << Match.new.from_csv( row )
    self
  end

end  # class Match



def load_matches( path_in )

  csv = CSV.read( path_in, headers: true )

  matches = []

  csv.each_with_index do |row,i|
    matches << Match.new.from_csv( row )
  end

  matches
end

