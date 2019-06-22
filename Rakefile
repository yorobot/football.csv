# encoding: utf-8


## note: use the local version of sportdb-source gem
$LOAD_PATH.unshift( File.expand_path( './sportdb-source/lib') )

require 'sportdb/source'

##  add sportdb/import too ?


### our own code


require './repos'


############################################
# add more tasks (keep build script modular)

Dir.glob('./tasks/**/*.rake').each do |r|
  puts " importing task >#{r}<..."
  import r
  # see blog.smartlogicsolutions.com/2009/05/26/including-external-rake-files-in-your-projects-rakefile-keep-your-rake-tasks-organized/
end
