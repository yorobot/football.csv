# encoding: utf-8



module SportDb
  module Struct


class Match

  attr_reader :date,
              :team1,   :team2,
              :score1,  :score2,
              :score1i, :score2i,
              :winner    # return 1,2,0   1 => team1, 2 => team2, 0 => draw/tie

  def initialize
    ## do nothing for now (use from_csv to setup data)
  end

  def self.create( **kwargs )
    self.new.update( kwargs )
  end

  def update( **kwargs )
    @date    = kwargs[:date]
    @team1   = kwargs[:team1]
    @team2   = kwargs[:team2]

    @score1  = kwargs[:score1]
    @score2  = kwargs[:score2]
    @score1i = kwargs[:score1i]
    @score2i = kwargs[:score2i]

    ## note: (always) (auto-)convert scores to integers
    @score1  = @score1.to_i   if @score1
    @score2  = @score2.to_i   if @score2
    @score1i = @score1i.to_i  if @score1i
    @score2i = @score2i.to_i  if @score2i


    ## todo/fix: auto-calculate winner
    # return 1,2,0   1 => team1, 2 => team2, 0 => draw/tie
    ### calculate winner - use 1,2,0
    if @score1 && @score2
       if @score1 > @score2
          @winner = 1
       elsif @score2 > @score1
          @winner = 2
       elsif @score1 == @score2
          @winner = 0
       else
       end
    else
      @winner = nil   # unknown / undefined
    end

    self   ## note - MUST return self for chaining
  end



  def over?()      true; end  ## for now all matches are over - in the future check date!!!
  def complete?()  true; end  ## for now all scores are complete - in the future check scores; might be missing - not yet entered


  def score_str    # pretty print (full time) scores; convenience method
    "#{@score1}-#{@score2}"
  end

  def scorei_str    # pretty print (half time) scores; convenience method
    "#{@score1i}-#{@score2i}"
  end

end  # class Match
end # module Struct



Structs = Struct ## add convenience alias (e.g. lets you use include SportDb::Structs)

end # module SportDb
