# encoding: utf-8

require_relative 'lib/read'

pp  'liga2'.to_i   # => 0
pp  'liga'.to_i    # => 0
pp  '3a'.to_i      # => 3
pp  '3b'.to_i      # => 3
pp  '3a-division'.to_i  # => 3
pp  '3b-division'.to_i  # => 3
pp  '01-division'.to_i  # => 1
pp  '1-division'.to_i   # => 1
pp  '2000'.to_i        # => 2000


pp LevelUtils.level( 'liga2' )   # => 999
pp LevelUtils.level( 'liga' )    # => 999
pp LevelUtils.level( '3' )       # => 999
pp LevelUtils.level( '3a' )      # => 999
pp LevelUtils.level( '3b' )      # => 999
pp LevelUtils.level( '3-division' )    # => 3
pp LevelUtils.level( '3a-division' )   # => 3
pp LevelUtils.level( '3b-division' )   # => 3
pp LevelUtils.level( '01-division' )   # => 1
pp LevelUtils.level( '1-division' )   #  => 1
pp LevelUtils.level( '2000-division' )   # => 999
