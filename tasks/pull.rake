# encoding: utf-8



#############
### add a pull a task to update all country repos
task :pull do |t|
  COUNTRY_REPOS.each do |k,v|
    country_code    = k
    country_path    = v

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

