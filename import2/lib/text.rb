# encoding: utf-8


#######################################
## add to sportdb-text
module CountryHelper ## use Helpers why? why not?

  def key( basename )
    if basename =~ /^([a-z]{2,3})-/    ## check for leading country code (e.g. sco-scotland)
      $1   ## return code as string e.g. "sco"
    else
      puts "sorry unknown country - cannot auto-map from >#{basename}< - add to CountryHelper to fix"
      exit 1
    end
  end
  def code( basename ) key( basename ); end  ## alias for country_key/code

end  # module CountryHelper


module CountryUtils
  extend CountryHelper
  ##  lets you use CountryHelper as "globals" eg.
  ##     CountryUtils.key( basename ) etc.
end # CountryUtils


module SeasonHelper ## use Helpers why? why not?
  def key( basename )
    ## todo: add 1964-1965 format too!!!
    if basename =~ /^(\d{4})-(\d{2})$/    ## season format is  1964-65
      "#{$1}/#{$2}"
    elsif basename =~ /^(\d{4})$/
      $1
    else
      puts "*** !!!! wrong season format >>#{basename}<<; exit; sorry"
      exit 1
    end
  end  # method key
end
