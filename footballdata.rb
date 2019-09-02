# encoding: utf-8

## note: use the local version of sportdb-source gem
$LOAD_PATH.unshift( File.expand_path( './sportdb-source-footballdata/lib') )

require 'sportdb/source/footballdata'


##
##  step 1: download
## Footballdata.fetch( :es, dir: './dl/footballdata' )
## Footballdata.fetch( :eng, :es, dir: './dl/footballdata', start: '2019/20' )



##
##  step 2: convert datasets
require './repos'


## use (switch to) "external" clubs datasets
## SportDb::Import.config.clubs_dir = "../../openfootball/clubs"


FOOTBALLDATA_SOURCES.each do |k,v|
  country_key     = k
  country_path    = COUNTRY_REPOS[k]
  country_sources = v

    next unless [:es, :eng].include?( country_key )

    out_dir = "../../footballcsv/#{country_path}"
    ## out_dir = "./o/footballdata/#{country_path}"

    Footballdata.convert_season_by_season( country_key, country_sources,
                            in_dir: './dl/footballdata',
                            out_dir: out_dir,
                            start: '2019/20' )
end
