# encoding: utf-8


module Footballdata

def self.convert( sources, in_dir:, out_dir: )

  in_root = in_dir   # e.g. "./dl/#{repo}"
  repo = File.basename( in_root )

  out_repo_path = out_dir   # e.g ".."

  ## e.g. ../../footballcsv/belgium
  ##  or  ./o/belgium etc.
  out_root = "#{out_repo_path}/#{repo}"    ## for "real" updates


  sources.each do |rec|
    dirname   = rec[0]   ## note: dirname is season e.g. 2011-12 etc.
    basenames = rec[1]   ## e.g. E1,E2,etc.

    basenames.each do |basename|

      in_path = "#{in_root}/#{dirname}/#{basename}.csv"

      league_key = FOOTBALLDATA_LEAGUES[basename]
      league_basename = league_key   ## e.g.: eng.1, fr.1, fr.2 etc.

      ## note: for de-deutschland, eng-england and es-espana
      ##   use long format e.g. 2010s/2011-12 etc
      if ['deutschland', 'england', 'espana'].include?( repo )
        out_path = "#{out_root}/#{SeasonUtils.directory(dirname, format: 'long')}/#{league_basename}.csv"
      else
        out_path = "#{out_root}/#{SeasonUtils.directory(dirname)}/#{league_basename}.csv"
      end

      puts "in_path: #{in_path}, out_path: #{out_path}"
      CsvMatchConverter.convert( in_path, out_path )
    end
  end


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
end
end # module Footballdata
