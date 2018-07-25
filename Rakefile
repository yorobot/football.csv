# encoding: utf-8

# 3rd party gems
require 'fetcher'


require_relative 'import/lib/read'



### our own code

require './repos'
require './footballdata'



############################################
# add more tasks (keep build script modular)

Dir.glob('./tasks/**/*.rake').each do |r|
  puts " importing task >#{r}<..."
  import r
  # see blog.smartlogicsolutions.com/2009/05/26/including-external-rake-files-in-your-projects-rakefile-keep-your-rake-tasks-organized/
end
