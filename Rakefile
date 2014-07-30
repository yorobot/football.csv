# encoding: utf-8

require 'csv'
require 'pp'


# 3rd party gems
require 'fetcher'


### our own code

require './sources'
require './leagues'
require './leagues_old'
require './teams'


countries = [
  [ :de, 'de-deutschland', DE_SOURCES ],
  [ :en, 'en-england',     EN_SOURCES ],
  [ :es, 'es-espana',      ES_SOURCES ],
  [ :fr, 'fr-france',      FR_SOURCES ],
  [ :it, 'it-italy',       IT_SOURCES ],
  [ :nl, 'nl-netherlands', NL_SOURCES ],
  [ :sco, 'sco-scotland',   SCO_SOURCES ],
  [ :be, 'be-belgium',     BE_SOURCES ],
  [ :pt, 'pt-portugal',    PT_SOURCES ],
  [ :tr, 'tr-turkey',      TR_SOURCES ],
  [ :gr, 'gr-greece',      GR_SOURCES ],
]


countries.each do |country|
  country_code    = country[0]
  country_path    = country[1]
  country_sources = country[2]

  ## define tasks for all countries
  task country_code do |t|
    convert_repo( country_path, country_sources )
  end

  task "get#{country_code}".to_sym do |t|
    fetch_repo( country_path, country_sources )
  end

  task "mv#{country_code}".to_sym do |t|
    rename_repo( country_path, country_sources )
  end
end

#############
### add a pull a task to update all country repos
task :pull do |t|
  countries.each do |country|
    country_code    = country[0]
    country_path    = country[1]

    ## save current wd
    savewd = Dir.pwd
    repo_path = "../#{country_path}"
    Dir.chdir( repo_path )

    puts "try git pull for #{country_path}"

    system 'git pull'

    # restore working folder
    Dir.chdir( savewd )
  end
end


# task :en do |t|
#  convert_repo( 'en-england', EN_SOURCES )
# end
#
# task :geten do |t|
#  fetch_repo( 'en-england', EN_SOURCES )
# end




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
        
        File.open( out_path, "wb" ) do |out|
          out.write txt
        end
      else
        puts " *** !!!! HTTP error #{response.code} - #{resonse.message}"
      end

    end
  end
end



def get_league( repo, year, basename)
  if year <= 2003 && repo == 'en-england'
    league = EN_LEAGUES_2003[basename]     ## hack: for england for now (make more generic???)
  elsif year <= 2001 && repo == 'fr-france'
    league = FR_LEAGUES_2001[basename]
  elsif year <= 1997 && repo == 'sco-scotland'
    league = SCO_LEAGUES_1997[basename]
  elsif year <= 2012 && repo == 'sco-scotland'
    league = SCO_LEAGUES_2012[basename]
  elsif year <= 2005 && repo == 'gr-greece'
    league = GR_LEAGUES_2005[basename]
  else
    league = LEAGUES[basename]
  end
  league
end

def get_old_league( repo, year, basename )
  if year <= 2003 && repo == 'en-england'
    league = OLD_EN_LEAGUES_2003[basename]     ## hack: for england for now (make more generic???)
  elsif year <= 2001 && repo == 'fr-france'
    league = OLD_FR_LEAGUES_2001[basename]
  elsif year <= 1997 && repo == 'sco-scotland'
    league = OLD_SCO_LEAGUES_1997[basename]
  elsif year <= 2012 && repo == 'sco-scotland'
    league = OLD_SCO_LEAGUES_2012[basename]
  elsif year <= 2005 && repo == 'gr-greece'
    league = OLD_GR_LEAGUES_2005[basename]
  else
    league = OLD_LEAGUES[basename]
  end
  league
end




def rename_repo( repo, sources )
  # e.g. rename   en-england/2001-02/premier-league to /1-premierleague etc.

  ## save current wd
  savewd = Dir.pwd

  repo_path = "../#{repo}"
  Dir.chdir( repo_path )

  puts "changed working folder to >>#{Dir.pwd}<<"

  sources.each do |rec|
    dirname   = rec[0]
    basenames = rec[1]
    
    basenames.each do |basename|

      ## get first year from dirname e.g.  2003-04  => 2003
      m = /(\d{4})/.match( dirname )
      if m
        year = m[1].to_i
      else
        year = 2020
      end

      league      = get_league( repo, year, basename )
      old_league  = get_old_league( repo, year, basename )

      new_path = "#{dirname}/#{league}.csv"
      old_path = "#{dirname}/#{old_league}.csv"

      ### puts "new_path: #{new_path}, old_path: #{old_path}"

      if File.exists?( old_path )
        puts "rename #{old_path} => #{new_path}"
        
        ### system "git mv #{old_path} #{new_path}"        
      else
        puts "*** file >>#{old_path}<< not found"   ## already renamed? skip?
      end      
    end
  end

  ### system "git add ."
  ### message = "files renamed at #{Time.now.utc}"
  ### system "git commit -m #{message.inspect}"
  ### system "git push"

  # restore working folder
  Dir.chdir( savewd )
  puts "restored working folder to >>#{Dir.pwd}<<"
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


def convert_csv( path_in, path_out )
  puts ''
  puts "convert >>#{path_in}<< to >>#{path_out}<<"

  csv = CSV.read( path_in, headers: true )

  ### todo/fix: check headers - how?
  ##  if present HomeTeam or HT required etc.
  ##   issue error/warn is not present
  ##
  ## puts "*** !!! wrong (unknown) headers format; cannot continue; fix it; sorry"
  ##    exit 1
  ##


  out = File.new( path_out, 'w' )
  out <<  "Date,Team 1,Team 2,FT,HT\n"  # add header

  csv.each_with_index do |row,i|

    puts "[#{i}] " + row.inspect  if i < 2

    values = []  
    values << row['Date']

    # note: greece 2001-02 etc. use HT  -  check CVS reader  row['HomeTeam'] may not be nil but an empty string?
    #   e.g. row['HomeTeam'] || row['HT'] will NOT work for now
    ht = row['HomeTeam']
    if ht.nil? || ht.strip.empty?   ## todo: check CVS reader - what does it return for non-existing valules/columns?
      ht = row['HT']  
    end

    at = row['AwayTeam']
    if at.nil? || at.strip.empty?
      at =row['AT']
    end

    values << ht
    values << at

    ## check if data present - if not skip (might be empty row)
    next if values[0].nil? && values[1].nil? && values[2].nil?  ## no date, no home team, no away team -- skip

    ## reformat date if present
    ##  - from 31/12/00 to 2000-12-31
    
    ##
    ##
    # check date format might be
    #  31/12/00
    # or
    #  17/08/2002  e.g.  E0 for 2002-03
    #
    #  if no match break/exist w/ error

    values[0] = values[0].strip   # make sure not leading or trailing spaces left over

    if values[0] =~ /^\d{2}\/\d{2}\/\d{4}$/
      date_fmt = '%d/%m/%Y'   # e.g. 17/08/2002
    elsif values[0] =~ /^\d{2}\/\d{2}\/\d{2}$/
      date_fmt = '%d/%m/%y'   # e.g. 17/08/02
    else
      puts "*** !!! wrong (unknown) date format >>#{values[0]}<<; cannot continue; fix it; sorry"
      exit 1
    end

    values[0] = Date.strptime( values[0], date_fmt ).strftime( '%Y-%m-%d' )

    ## reformat team if match  (e.g. Bayern Munich => Bayern München etc.)
    values[1] = TEAMS[ values[1] ]   if TEAMS[ values[1] ]
    values[2] = TEAMS[ values[2] ]   if TEAMS[ values[2] ]

    values << "#{row['FTHG']}-#{row['FTAG']}"     # e.g. 1-0  or 3-1 etc. for full time (ft) goals/score

    ## check for half time scores ?
    if row['HTHG'].nil? || row['HTAG'].nil?
      # no (or incomplete) half time socre; add empty
      values << ''
    else
      values << "#{row['HTHG']}-#{row['HTAG']}"
    end
  

    out << values.join( ',' )
    out << "\n"
  end

  out.close
end
