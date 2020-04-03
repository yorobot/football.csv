
def command( cmd )
    ## note: for now use Kernel#system for calling external git command
    ##

    cmdline = cmd
    puts "  trying >#{cmdline}< in (#{Dir.pwd})..."
    
    result = nil
    result = system( cmdline )

    pp result

    # note: Kernel#system returns
    #  - true if the command gives zero exit status
    #  - false for non zero exit status
    #  - nil if command execution fails
    #  An error status is available in $?.

    if result.nil?
      puts "*** error was #{$?}"
      fail "[Kernel.system] command execution failed  >#{cmdline}< - #{$?}"   
    elsif result   ## true => zero exit code (OK)
      puts 'OK'  ## zero exit; assume OK
      true   ## assume ok
    else  ## false => non-zero exit code (ERR/NOK)
      puts "*** error: non-zero exit - #{$?} !!"   ## non-zero exit (e.g. 1,2,3,etc.); assume error
    
      ## log error for now  ???
      # File.open( './errors.log', 'a' ) do |f|
      #  f.write "#{Time.now} -- repo #{@owner}/#{@name} - command execution failed - non-zero exit\n"
      # end
      fail "command execution failed >#{cmdline}< - non-zero exit (#{$?})"
    end
 end  # method command



def git_pull( repo_path )
    savewd = Dir.pwd    # save current wd
  
    Dir.chdir( repo_path )
  
    puts "try git pull for >#{File.basename( repo_path )}< in (#{Dir.pwd})"
  
    command 'git pull'
    ## todo/fix: check print/return value
  
    Dir.chdir( savewd )    # restore working folder
end
  

def git_commit( repo_path )
    savewd = Dir.pwd    # save current wd
  
    Dir.chdir( repo_path )
  
    puts "try git commit for >#{File.basename( repo_path )}< in (#{Dir.pwd})"
  
    command 'git status'
    command 'git add .'
    command 'git status'
    command 'git commit -m up'
    command 'git push'
  
    ## todo/fix: check print/return value
    ##   see hubba/gitti
  
    Dir.chdir( savewd )    # restore working folder
end
  