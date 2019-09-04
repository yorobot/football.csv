# encoding: utf-8

## note: use the local version of sportdb-source gem
$LOAD_PATH.unshift( File.expand_path( './sportdb-source-footballdata/lib') )

require 'sportdb/source/footballdata'


##
##  step 1: download
## Footballdata.fetch( dir: './dl/footballdata' )
## Footballdata.fetch( :es, dir: './dl/footballdata' )
## Footballdata.fetch( :eng, :es, dir: './dl/footballdata', start: '2019/20' )




##
##  step 2: convert datasets
require './repos'


## use (switch to) "external" clubs datasets
SportDb::Import.config.clubs_dir = "../../openfootball/clubs"



def git_pull( repo_path )
  savewd = Dir.pwd    # save current wd

  Dir.chdir( repo_path )

  puts "try git pull for >#{File.basename( repo_path )}< in (#{Dir.pwd})"

  system 'git pull'
  ## todo/fix: check print/return value

  Dir.chdir( savewd )    # restore working folder
end

def git_commit( repo_path )
  savewd = Dir.pwd    # save current wd

  Dir.chdir( repo_path )

  puts "try git commit for >#{File.basename( repo_path )}< in (#{Dir.pwd})"

  system 'git status'
  system 'git add .'
  system 'git status'
  system 'git commit -m up'
  system 'git push'

  ## todo/fix: check print/return value
  ##   see hubba/gitti

  Dir.chdir( savewd )    # restore working folder
end



FOOTBALLDATA_SOURCES.each do |k,v|
  country_key     = k
  country_path    = COUNTRY_REPOS[k]
  country_sources = v

    next unless [:gr].include?( country_key )

    out_dir = "../../footballcsv/#{country_path}"
    ## out_dir = "./o/footballdata/#{country_path}"

    git_pull( out_dir )
    print "hit return to continue: ";  ch=STDIN.getc

    Footballdata.convert_season_by_season( country_key, country_sources,
                            in_dir: './dl/footballdata',
                            out_dir: out_dir,
                            start: '2018/19' )

    print "hit return to commit: ";  ch=STDIN.getc
    git_commit( out_dir )
end
