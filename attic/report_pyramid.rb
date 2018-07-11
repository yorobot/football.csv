
  level_keys = levels.keys
  buf << "#{level_keys.size} levels: #{level_keys.join(' ')}\n\n"

  ## loop 1) summary
  level_keys.each do |level|
    level_hash = levels[level]
    season_keys = level_hash.keys
    buf << "level #{level} - #{season_keys.size} seasons: #{season_keys.join(' ')}"
    buf << "\n\n"
  end


  ## loop 2) details
  level_keys.each do |level|   ## change level to level_key!!!
    level_hash = levels[level]
    season_keys = level_hash.keys
    buf << "level #{level} - #{season_keys.size} seasons: #{season_keys.join(' ')}"
    buf << "\n\n"
    season_keys.each_with_index do |season,i|    ## change season to season_key!!!
      buf << "season #{season}:\n"

      ## todo: check for gap e.g. warn about missing season year
      last_season = season_keys[i+1]
      if last_season
          buf << "diff #{season} with #{last_season}:\n"

          season_recs      = level_hash[ season ]
          last_season_recs = level_hash[ last_season ]

          ## for now compare only first datafile (assume single datafile)
          diff_up   = season_recs[0] - last_season_recs[0]
          diff_down = last_season_recs[0] - season_recs[0]

          buf << "#{season_recs[0].size} teams: #{season_recs[0].join(', ')}\n"
          buf << "  - (++) new in season - up (#{diff_up.size}): #{diff_up.join(', ')}\n"
          buf << "  - (--) down (#{diff_down.size}): #{diff_down.join(', ')}\n"
      end
    end
  end
