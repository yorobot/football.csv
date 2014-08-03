# encoding: utf-8


# task :en do |t|
#  convert_repo( 'en-england', EN_SOURCES )
# end
#
# task :geten do |t|
#  fetch_repo( 'en-england', EN_SOURCES )
# end


FOOTBALLDATA_SOURCES.each do |k,v|
  country_code    = k
  country_path    = COUNTRY_REPOS[k]
  country_sources = v

  ## define tasks for all countries
  task country_code do |t|
    convert_repo( country_path, country_sources )
  end

  task "get#{country_code}".to_sym do |t|
    fetch_repo( country_path, country_sources )
  end
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
        
        File.open( out_path, 'wb' ) do |out|
          out.write txt
        end
      else
        puts " *** !!!! HTTP error #{response.code} - #{resonse.message}"
      end

    end
  end
end



def convert_repo( repo, sources )

  in_root  = "./dl/#{repo}"
  out_root = "./o/#{repo}"

  sources.each do |rec|
    dirname   = rec[0]
    basenames = rec[1]
    
    basenames.each do |basename|

      in_path = "#{in_root}/#{dirname}/#{basename}.csv"

      ## get first year from dirname e.g.  2003-04  => 2003
      m = /(\d{4})/.match( dirname )
      if m
        year = m[1].to_i
      else
        year = 2020
      end

      league      = get_league( repo, year, basename )

      out_path = "#{out_root}/#{dirname}/#{league}.csv"

      puts "in_path: #{in_path}, out_path: #{out_path}"

      ## makedirs_p for out_path
      FileUtils.mkdir_p( File.dirname(out_path) )   unless Dir.exists?( File.dirname( out_path ))
 
      convert_csv( in_path, out_path )
    end
  end
end

