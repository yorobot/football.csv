# encoding: utf-8


module Footballdata


def self.fetch_season_by_season( sources, dir:, start: )   ## format i - one datafile per season
  download_base  = "http://www.football-data.co.uk/mmz4281"

  sources.each do |rec|
    season_key = rec[0]   ## note: dirname is season_key e.g. 2011-12 etc.
    basenames  = rec[1]

    if start && SeasonUtils.start_year( season_key ) < SeasonUtils.start_year( start )
      puts "skip #{season_key} before #{start}"
      next
    end

    basenames.each do |basename|
      season_path = season_key[2..3]+season_key[5..6]  # e.g. 2008-09 becomse 0809 etc
      url = "#{download_base}/#{season_path}/#{basename}.csv"

      path = "#{dir}/#{season_key}/#{basename}.csv"

      puts " url: >>#{url}<<, path: >>#{path}<<"

      ## note: be friendly sleep 500ms (0.5secs)
      sleep( 0.5 )
      txt = get( url )

      ## make sure parent folders exist
      FileUtils.mkdir_p( File.dirname(path) )   unless Dir.exists?( File.dirname( path ))
      File.open( path, 'w:utf-8' ) do |out|
          out.write txt
      end
    end
  end
end


def self.fetch_all_seasons( basename, dir: )   ## format ii - all-seasons-in-one-datafile
  download_base  = "http://www.football-data.co.uk/new"

  url  = "#{download_base}/#{basename}.csv"
  path = "#{dir}/#{basename}.csv"

  puts " url: >>#{url}<<, path: >>#{path}<<"

  sleep( 0.5 )
  txt = get( url )

  ## make sure parent folders exist
  FileUtils.mkdir_p( File.dirname(path) )   unless Dir.exists?( File.dirname( path ))
  File.open( path, 'w:utf-8' ) do |out|
      out.write txt
  end
end


def self.get( url )
  worker = Fetcher::Worker.new
  response = worker.get( url )

  if response.code == '200'
    txt = response.body

## [debug] GET=http://www.football-data.co.uk/mmz4281/0405/SC0.csv
##    Encoding::UndefinedConversionError: "\xA0" from ASCII-8BIT to UTF-8
##     note:  0xA0 (160) is NBSP (non-breaking space) in Windows-1252

    ## note: assume windows encoding (for football-data.uk)
    ##   use "Windows-1252" for input and convert to utf-8
    ##
    ##    see https://www.justinweiss.com/articles/3-steps-to-fix-encoding-problems-in-ruby/
    ##    see https://en.wikipedia.org/wiki/Windows-1252

    txt = txt.force_encoding( 'Windows-1252' )
    txt = txt.encode( 'UTF-8' )

    ## fix: newlines - always use "unix" style"
    txt = txt.gsub( "\r\n", "\n" )
    txt
  else
    puts " *** !!!! HTTP error #{response.code} - #{resonse.message}"
    exit 1
  end
end


end # module Footballdata
