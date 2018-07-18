# encoding: utf-8


module SeasonHelper ## use Helpers why? why not?
  def prev( season )
    ## todo: add 1964-1965 format too!!!
    if season =~ /^(\d{4})-(\d{2})$/    ## season format is  1964-65
      fst = $1.to_i - 1
      snd = (100 + $2.to_i - 1) % 100    ## note: add 100 to turn 00 => 99
      "%4d-%02d" % [fst,snd]
    elsif season =~ /^(\d{4})$/
      fst = $1.to_i - 1
      "%4d" % [fst]
    else
      puts "*** !!!! wrong season format >>#{season}<<; exit; sorry"
      exit 1
    end
  end  # method prev



  def directory( season )
    ## convert season name to "standard" season name for directory
    season = season.tr('/','-')  ## todo/fix: use [\-/] in regex directly!!!
    if season =~ /^(\d{4})-(\d{4})$/   ## e.g. 2011-2010 or 2011/2011 => 2011-10
      "%4d-%02d" % [$1.to_i, $2.to_i % 100]
    elsif season =~ /^(\d{4})-(\d{2})$/
      "%4d-%02d" % [$1.to_i, $2.to_i]
    elsif season =~ /^(\d{4})$/
      "%4d" % [$1.to_i]
    else
      puts "*** !!!! wrong season format >>#{season}<<; exit; sorry"
      exit 1
    end
  end


  def start_year( season ) ## get start year
    ## convert season name to "standard" season name for directory

    ## todo/check:  just return year from first for chars - keep it simple - why? why not?
    season = season.tr('/','-')  ## todo/fix: use [\-/] in regex directly!!!
    if season =~ /^(\d{4})-(\d{4})$/   ## e.g. 2011-2010 or 2011/2011 => 2011-10
      $1
    elsif season =~ /^(\d{4})-(\d{2})$/
      $1
    elsif season =~ /^(\d{4})$/
      $1
    else
      puts "*** !!!! wrong season format >>#{season}<<; exit; sorry"
      exit 1
    end
  end

  def end_year( season ) ## get end year
    ## convert season name to "standard" season name for directory
    season = season.tr('/','-')  ## todo/fix: use [\-/] in regex directly!!!
    if season =~ /^(\d{4})-(\d{4})$/   ## e.g. 2011-2010 or 2011/2011 => 2011-10
      $2
    elsif season =~ /^(\d{4})-(\d{2})$/
      ## note: assume second year is always +1
      ##    todo/fix: add assert/check - why? why not?
      ## eg. 1999-00 => 2000 or 1899-00 => 1900
      ($1.to_i+1).to_s
    elsif season =~ /^(\d{4})$/
      $1
    else
      puts "*** !!!! wrong season format >>#{season}<<; exit; sorry"
      exit 1
    end
  end


  def pretty_print( seasons )
    ## e.g. ['2015-16', '2014-15', '2013-14', '1999-00', '1998-99', '1993-94']
    ##      => (old) 2015-16..2013-14 (3) 1999-00..1998-99 (2) 1993-94
    ##      => (new) 2016...2013 (3) 2000..1998 (2) 1993-94   - why? why not?
    ##  or
    ##      ['2014-15', '1994-95']
    ##      => 2014-15 1994-95
    ##  or
    ##      ['2017-18', '2016-17', '2015-16', '2014-15', '2013-14', '2012-13', '2011-12', '2010-11', '2009-10', '2008-09', '2006-07', '2005-06', '2004-05', '2003-04']
    ##      => 2018......2008 (10) 2006-07..2003-04 (4)

    ## first sort by latest (newest) first
    seasons = seasons.sort.reverse

    ## step 1: collect seasons in runs
    runs = []
    seasons.each do |season|

      run = runs[-1]  ## get last run (note: returns nil if empty)

      if run.nil?
        ## start new run - very first season / item
        run = []
        run << season
        runs << run
      else
        season_prev = run[-1]  ## get last season from run
        year_prev   = season_prev[0..3].to_i  ## get year

        year = season[0..3].to_i  ## get year (from season) eg. 2015-16 => 2015

        if year == year_prev-1   ## keep adding to run
          run << season
        else ## start new run
          run = []
          run << season
          runs << run
        end
      end
    end

    ## step 2: print runs into buffer (string)
    buf = ''
    runs.each do |run|
       if run.size == 1
          buf << "#{run[0]} "
       else
          ## use first and last season
          ##  try for now use .. (2)
          ##                  ... (3)
          ##                  ..... (4) etc.

          ## was: buf << run[0]
          ##  for 2017-18  print => 2018

          buf << end_year( run[0] )
          buf << ('.' * run.size)
          buf << start_year( run[-1] )
          buf << " (#{run.size}) "
       end
    end
    buf = buf.strip   # remove trainling space(s)
    buf
  end

end  # module SeasonHelper


module SeasonUtils
  extend SeasonHelper
  ##  lets you use SeasonHelper as "globals" eg.
  ##     SeasonUtils.prev( season ) etc.
end # SeasonUtils
