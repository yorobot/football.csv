# encoding: utf-8

## note: use the local version of sportdb-source gem
$LOAD_PATH.unshift( File.expand_path( './sportdb-source-footballdata/lib') )

require 'sportdb/source/footballdata'


##
##  step 1: download
## Footballdata.fetch( :gr, dir: './dl/footballdata' )



##
##  step 2: convert datasets
require './repos'


## use (switch to) "external" clubs datasets
SportDb::Import.config.clubs_dir = "../../openfootball/clubs"


FOOTBALLDATA_SOURCES.each do |k,v|
  country_key     = k
  country_path    = COUNTRY_REPOS[k]
  country_sources = v

    next unless [:gr].include?( country_key )

    ## out_dir = ".."
    ## out_dir = "../../footballcsv"
    ## out_dir = "./o"    ## for debugging / testing
    out_dir = "./o/footballdata/#{country_path}"

    Footballdata.convert_season_by_season( country_key, country_sources,
                            in_dir: './dl/footballdata',
                            out_dir: out_dir )
end
