# encoding: utf-8


# task :en do |t|
#  convert_repo( 'en-england', EN_SOURCES )
# end
#
# task :geten do |t|
#  fetch_repo( 'en-england', EN_SOURCES )
# end


## note: define tasks for all countries
FOOTBALLDATA_SOURCES.each do |k,v|
  country_code    = k
  country_path    = COUNTRY_REPOS[k]
  country_sources = v

  ## step 1: fetch (download) datasets
  task "get#{country_code}".to_sym do |t|
    fetch_repo( country_path, country_sources )
  end

  ## step 2: convert datasets
  task country_code do |t|
    convert_repo( country_path, country_sources )
  end
end

task :getall => FOOTBALLDATA_SOURCES.keys.map {|key| "get#{key}".to_sym }  do |t|
end



def fetch_repo( repo, sources )
  in_base  = "http://www.football-data.co.uk/mmz4281"
  out_root = "./dl/#{repo}"

  sources.each do |rec|
    dirname   = rec[0]
    basenames = rec[1]

    basenames.each do |basename|
      season_path = dirname[2..3]+dirname[5..6]  # e.g. 2008-09 becomse 0809 etc
      in_url = "#{in_base}/#{season_path}/#{basename}.csv"

      out_path = "#{out_root}/#{dirname}/#{basename}.csv"

      puts " in_url: >>#{in_url}<<, out_path: >>#{out_path}<<"

      ## make sure parent folders exist
      FileUtils.mkdir_p( File.dirname(out_path) )   unless Dir.exists?( File.dirname( out_path ))

      worker = Fetcher::Worker.new
      response = worker.get( in_url )

      if response.code == '200'
        txt = response.body

## [debug] GET=http://www.football-data.co.uk/mmz4281/0405/SC0.csv
##    Encoding::UndefinedConversionError: "\xA0" from ASCII-8BIT to UTF-8

        ## note: assume windows encoding (for football-data.uk)
        ##  convert to utf-8
        ##   use "Windows-1252" for input - why? why not?
        ##    see https://www.justinweiss.com/articles/3-steps-to-fix-encoding-problems-in-ruby/

        txt = txt.force_encoding( 'ISO-8859-1' )
        txt = txt.encode( 'UTF-8' )

        ## fix: newlines - always use "unix" style"
        txt = txt.gsub( "\r\n", "\n" )

        ## todo/fix: for txt encoding to utf-8 - why? why not?
        File.open( out_path, 'w:utf-8' ) do |out|
          out.write txt
        end
      else
        puts " *** !!!! HTTP error #{response.code} - #{resonse.message}"
        exit 1
      end

    end
  end
end



def convert_repo( repo, sources )

  in_root  = "./dl/#{repo}"

  out_repo_path = "../../footballcsv"
  ## out_repo_path = "./o"    ## for debugging / testing


  ## e.g. ../../footballcsv/be-belgium or ./o/be-belgium etc.
  out_root = "#{out_repo_path}/#{repo}"    ## for "real" updates


  sources.each do |rec|
    dirname   = rec[0]   ## note: dirname is season e.g. 2011-12 etc.
    basenames = rec[1]   ## e.g. E1,E2,etc.

    basenames.each do |basename|

      in_path = "#{in_root}/#{dirname}/#{basename}.csv"

      ## get first year from dirname e.g.  2003-04  => 2003
      m = /(\d{4})/.match( dirname )
      if m
        year = m[1].to_i
      else
        ## year = 2020
        puts "missing year (season) in dir >#{dirname}<; sorry"
        exit 1
      end

      ## build season from season_start_year e.g. 2003 => 2003-04 etc.
      season = "%4d-%02d" % [year, (year+1)%100]

      league_key = FOOTBALLDATA_LEAGUES[basename]
      ## e.g.: eng.1, fr.1, fr.2 etc.  split into country and level
      ## note: use level as string e.g. '1', '2'
      league_country, league_level  = league_key.split( '.' )


      league_basename = LeagueUtils.basename( league_level,
                                       country: league_country,
                                       season:  season )

      ## note: for de-deutschland and eng-england
      ##   use long format e.g. 2010s/2011-12 etc
      if ['de-deutschland', 'eng-england'].include?( repo )
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

  pack = CsvPackage.new( "#{out_repo_path}/#{repo}" )

  ### todo:
  ## use all-in-one   pack.update_reports - why? why not?

  summary_report = CsvSummaryReport.new( pack )
  summary_report.write
  ## note: write same as summary.save( "#{out_root}/SUMMARY.md" )

  ## standings_writer = CsvStandingsWriter.new( pack )
  ## standings_writer.write
end
