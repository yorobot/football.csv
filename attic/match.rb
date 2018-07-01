

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

  
