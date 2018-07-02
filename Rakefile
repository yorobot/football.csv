# encoding: utf-8

require 'csv'
require 'pp'


# 3rd party gems
require 'fetcher'



require_relative 'import/lib/read'



### our own code

require './repos'
require './leagues'
require './footballdata'





require './scripts/utils'
require './scripts/leagues'


############################################
# add more tasks (keep build script modular)

Dir.glob('./tasks/**/*.rake').each do |r|
  puts " importing task >#{r}<..."
  import r
  # see blog.smartlogicsolutions.com/2009/05/26/including-external-rake-files-in-your-projects-rakefile-keep-your-rake-tasks-organized/
end
