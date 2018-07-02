
## note: sort levels
##   always let 1 go before 2 before 3 etc.
##    note  2 (33), 1 (11) or similar in "random" order
sorted_levels = t.levels.to_a.sort do |l,r|
  l[0] <=> r[0]    ## sort by (former) hash key
end

buf << " / #{sorted_levels.size} levels - "
sorted_levels.each_with_index do |level, k|
  buf << ", " if k > 0
  buf << "#{level[0]} (#{level[1].seasons.size})"
end
