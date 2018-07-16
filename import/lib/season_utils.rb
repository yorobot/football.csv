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


  ## todo: add self.prettyprint (or pretty_print)
end  # module SeasonHelper


module SeasonUtils
  extend SeasonHelper
  ##  lets you use SeasonHelper as "globals" eg.
  ##     SeasonUtils.prev( season ) etc.
end # SeasonUtils
