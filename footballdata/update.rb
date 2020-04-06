require_relative 'boot'
require_relative 'repos'
require_relative 'git'





def convert_season_by_season( *args, start: nil )
  country_keys = args  ## countries to include / fetch - optinal

FOOTBALLDATA_SOURCES.each do |k,v|
  country_key     = k
  country_path    = COUNTRY_REPOS[k]
  country_sources = v

    next unless country_keys.include?( country_key )

    out_dir = "../../../footballcsv/#{country_path}"

    git_pull( out_dir )
    print "hit return to continue: ";  ch=STDIN.getc

    Footballdata.convert_season_by_season( country_key, country_sources,
                            in_dir: './dl',
                            out_dir: out_dir,
                            start: start,
                            normalize: true )

    print "hit return to commit: ";  ch=STDIN.getc
    git_commit( out_dir )
end
end  # method convert_season_by_season




def convert_all_seasons( *args, start: nil )
  country_keys = args  ## countries to include / fetch - optinal

FOOTBALLDATA_SOURCES_II.each do |k,v|
  country_key     = k
  country_path    = COUNTRY_REPOS[k] || 'world'   ## note: if missing, fallback to world repo
  basename        = v

    next unless country_keys.include?( country_key )

    out_dir = "../../../footballcsv/#{country_path}"

    git_pull( out_dir )
    print "hit return to continue: ";  ch=STDIN.getc

    Footballdata.convert_all_seasons( country_key, basename,
                            in_dir: './dl',
                            out_dir: out_dir,
                            start: start,
                            normalize: true )

    print "hit return to commit: ";  ch=STDIN.getc
    git_commit( out_dir )
end
end  # method convert_all_seasons



##
##  step 1: download
## Footballdata.fetch( dir: './dl/footballdata' )
## Footballdata.fetch( :es, dir: './dl/footballdata' )
## Footballdata.fetch( :eng, :es, dir: './dl/footballdata', start: '2019/20' )

##
##  step 2: convert datasets

## use (switch to) "external" clubs datasets
## SportDb::Import.config.clubs_dir = "../../openfootball/clubs"

=begin
[:eng, 
 :sco, 
 :de, 
 :it, 
 :es, 
 :fr,
 :nl,
 :be,
 :pt,
 :tr,
 :gr
 ].each do |key|
  convert_season_by_season( key, start: '2019/20' )
end
=end

# convert_season_by_season( :gr )
convert_all_seasons( :ar )

## convert_all_seasons( :at, start: '2018/19' )
## convert_all_seasons( :mx )
