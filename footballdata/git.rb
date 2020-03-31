
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
  