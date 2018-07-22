# encoding: utf-8


def save_season( out_root, league, season, headers, recs )

  if season =~ /^\d{4}-\d{4}$/    ## season format is 1964-1965
    decade_path = "#{season[0..2]}0s"
    season_path = "#{season[0..3]}-#{season[7..8]}"   ## change 1964-1965 to 1964-65
  elsif season =~ /^\d{4}$/
    decade_path = "#{season[0..2]}0s"
    season_path = "#{season}-#{(season.to_i+1).to_s[2..3]}"   ## change 1964 to 1964-65 or 1999 to 1999-00
  else
    puts "*** !!!! wrong season format >>#{season}<<; exit; sorry"
    exit 1
  end


  out_path = "#{out_root}/#{decade_path}/#{season_path}/#{league}.csv"

  puts "saving >>#{out_path}<< #{recs.size} records..."

  ## dry_run = true
  dry_run = false

  if dry_run
    ## do NOT write anything to disk; do nothing for now
  else
    ## make sure parent folders exist
    FileUtils.mkdir_p( File.dirname(out_path) )  unless Dir.exists?( File.dirname( out_path ))

    File.open( out_path, 'w' ) do |out|
      out.puts headers.join(',')    # headers line
      ## all recs
      recs.each do |rec|
        out.puts rec.join(',')
      end
    end
  end
end
