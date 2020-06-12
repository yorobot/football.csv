require_relative 'boot'
require_relative 'repos'



def convert_season_by_season( *args, start: nil )
  country_keys = args  ## countries to include / fetch - optinal

FOOTBALLDATA_SOURCES.each do |k,v|
  country_key     = k
  country_path    = COUNTRY_REPOS[k]
  country_sources = v

    next unless country_keys.include?( country_key )

    out_dir = "./o/#{country_path}"

    Footballdata.convert_season_by_season( country_key, country_sources,
                            in_dir: './dl',
                            out_dir: out_dir,
                            start: start )
end
end  # method convert_season_by_season


def convert_all_seasons( *args, start: nil )
  country_keys = args  ## countries to include / fetch - optinal

FOOTBALLDATA_SOURCES_II.each do |k,v|
  country_key     = k
  country_path    = COUNTRY_REPOS[k] || 'world'   ## note: if missing, fallback to world repo
  basename        = v

    next unless country_keys.include?( country_key )

    out_dir = "./o/#{country_path}"

    Footballdata.convert_all_seasons( country_key, basename,
                            in_dir: './dl',
                            out_dir: out_dir,
                            start: start )
end
end  # method convert_all_seasons



  ###################################################
  ## (auto-) add / update SUMMARY.md report
  ## (auto-) add ) update README.md pages with standings

  ## pack = CsvPackage.new( "#{out_repo_path}/#{repo}" )

  ### todo:
  ## use all-in-one   pack.update_reports - why? why not?

  # summary_report = CsvSummaryReport.new( pack )
  # summary_report.write
  ## note: write same as summary.save( "#{out_root}/SUMMARY.md" )

  ## standings_writer = CsvStandingsWriter.new( pack )
  ## standings_writer.write


##
##  step 1: download
## Footballdata.fetch( dir: './dl/footballdata' )
## Footballdata.fetch( :es, dir: './dl/footballdata' )
## Footballdata.fetch( :eng, :es, dir: './dl/footballdata', start: '2019/20' )

##
##  step 2: convert datasets

def write_summary( path )
  pack = CsvPackage.new( path )

  summary_report = CsvSummaryReport.new( pack )
  summary_report.write
end


# convert_season_by_season( :eng, start: '2019/20' )
# convert_all_seasons( :at, start: '2018/19' )
# convert_all_seasons( :mx )

write_summary( './o/austria' )
write_summary( './o/mexico' )
write_summary( './o/england' )

# pack = CsvPackage.new( './o/austria' )
# puts CsvTeamsReport.new( pack ).build

puts "bye"