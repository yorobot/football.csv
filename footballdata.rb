# encoding: utf-8

## note: use the local version of sportdb-source gem
$LOAD_PATH.unshift( File.expand_path( './sportdb-source-footballdata/lib') )

require 'sportdb/source/footballdata'


##
##  download
## Footballdata.fetch( dir: './dl/footballdata' )

require './repos'



FOOTBALLDATA_SOURCES.each do |k,v|
  country_key     = k
  country_path    = COUNTRY_REPOS[k]
  country_sources = v

  ## step 2: convert datasets
    ## out_dir = ".."
    ## out_dir = "../../footballcsv"
    ## out:dir = "./o"    ## for debugging / testing
    next unless country_key == :it
    Footballdata.convert_season_by_season( country_key, country_sources,
                            in_dir: './dl/footballdata',
                            out_dir: "./o/footballdata/#{country_path}" )
end
