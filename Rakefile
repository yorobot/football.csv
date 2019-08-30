# encoding: utf-8


## note: use the local version of sportdb-source gem
$LOAD_PATH.unshift( File.expand_path( './sportdb-source-footballdata/lib') )

require 'sportdb/source/footballdata'


##  add sportdb/import too - why? why not?



### our own code

require './repos'


############################################
# add more tasks (keep build script modular)

Dir.glob('./tasks/**/*.rake').each do |r|
  puts " importing task >#{r}<..."
  import r
  # see blog.smartlogicsolutions.com/2009/05/26/including-external-rake-files-in-your-projects-rakefile-keep-your-rake-tasks-organized/
end
