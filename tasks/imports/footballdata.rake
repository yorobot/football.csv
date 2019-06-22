# encoding: utf-8


## note: define tasks for all countries
FOOTBALLDATA_SOURCES.each do |k,v|
  country_code    = k
  country_path    = COUNTRY_REPOS[k]
  country_sources = v

  ## step 1: fetch (download) datasets
  task "get#{country_code}".to_sym do |t|
    Footballdata.fetch( country_sources, out_dir: "./dl/#{country_path}" )
  end

  ## step 2: convert datasets
  task country_code do |t|
    ## out_dir = ".."
    ## out_dir = "../../footballcsv"
    ## out:dir = "./o"    ## for debugging / testing

    Footballdata.convert( country_sources, in_dir: "./dl/#{country_path}",
                                           out_dir: './o' )
  end
end

## note: define tasks for all countries
FOOTBALLDATA_SOURCES_II.each do |k,basename|
  country_code    = k

  ## step 1: fetch (download) datasets
  task "get#{country_code}".to_sym do |t|
    Footballdata.fetch_ii( basename, out_dir: './dl' )
  end

  ## step 2: convert datasets
  task country_code do |t|
    convert_repo_ii( basename )
  end
end


task :getall => FOOTBALLDATA_SOURCES.keys.map {|key| "get#{key}".to_sym }  do |t|
end

task :getall_ii => FOOTBALLDATA_SOURCES_II.keys.map {|key| "get#{key}".to_sym }  do |t|
end
