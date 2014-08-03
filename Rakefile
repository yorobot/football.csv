# encoding: utf-8

require 'csv'
require 'pp'


# 3rd party gems
require 'fetcher'


### our own code

require './repos'
require './leagues'
require './leagues_old'
require './teams'
require './footballdata'


require './scripts/standings'
require './scripts/utils'
require './scripts/leagues'
require './scripts/convert'



############################################
# add more tasks (keep build script modular)

Dir.glob('./tasks/**/*.rake').each do |r|
  puts " importing task >#{r}<..."
  import r
  # see blog.smartlogicsolutions.com/2009/05/26/including-external-rake-files-in-your-projects-rakefile-keep-your-rake-tasks-organized/
end


