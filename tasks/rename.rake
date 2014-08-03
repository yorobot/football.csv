# encoding: utf-8


COUNTRY_REPOS.each do |k,v|
  country_code    = k
  country_path    = v

#  todo/fix: cleanup to be done
#
#  country_sources = country[2]
#
#  task "mv#{country_code}".to_sym do |t|
#    rename_repo( country_path, country_sources )
#  end
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
