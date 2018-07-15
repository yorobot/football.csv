# encoding: utf-8




def find_seasons_in_txt( path )

  seasons = Hash.new( 0 )   ## default value is 0

  csv = CSV.read( path, headers: true )

  csv.each_with_index do |row,i|
    puts "[#{i}] " + row.inspect  if i < 2

    season = row['Season']
    seasons[ season ] += 1
  end

  pp seasons

  ## note: only return season keys/names (not hash with usage counter)
  seasons.keys
end
