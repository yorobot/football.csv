# encoding: utf-8


def rename_repo( repo_path, key )
  # e.g. rename   eng-england/2001-02/1-premierleague.csv to eng.1.csv etc.

  ## save current wd
  savewd = Dir.pwd

  Dir.chdir( repo_path )

  puts "changed working folder to >>#{Dir.pwd}<<"

  season_patterns = [
    '[0-9][0-9][0-9][0-9]-[0-9][0-9]',  ## e.g. /1998-99/
    '[0-9][0-9][0-9][0-9]'              ## e.g  /1999/  - note: will NOT include /1990s etc.
  ]

  datafile_paths = Dir.glob( "./**/{#{season_patterns.join(',')}}/*.csv" )
  datafile_paths.each_with_index do |datafile_path,i|
     puts "[#{i+1}/#{datafile_paths.size}] #{datafile_path}"

     dirname  = File.dirname( datafile_path )
     basename = File.basename( datafile_path )

     m = /^(\d{1,2}[a-z]?)-/.match( basename )
     if m
       div = m[1]   ## division

       old_path = datafile_path
       new_path = "#{dirname}/#{key}.#{div}.csv"
       cmd = "git mv #{old_path} #{new_path}"
       puts "  #{cmd}"
       ## system cmd
     else
       puts "!! divsion missing in datafile basename - sorry"
       exit 1
     end
  end
end


rename_repo( "../deutschland", "de" )

__END__
  ### system "git add ."
  ### message = "files renamed at #{Time.now.utc}"
  ### system "git commit -m #{message.inspect}"
  ### system "git push"
