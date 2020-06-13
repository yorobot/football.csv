require 'csvreader'
require 'fileutils'


## todo/fix: move CsvMatchWriter to its own file!!!!!
class CsvMatchWriter

    def self.write( path, recs )

      ## for convenience - make sure parent folders/directories exist
      FileUtils.mkdir_p( File.dirname( path ))  unless Dir.exist?( File.dirname( path ))

      headers = [
        'Matchday',
        'Date',
        'Time',
        'Team 1',
        'FT',
        'HT',
        'Team 2'
      ]

      File.open( path, 'w:utf-8' ) do |f|
        f.write headers.join(',')   ## e.g. Date,Team 1,FT,HT,Team 2
        f.write "\n"
        recs.each do |rec|
            f.write rec.join(',')
            f.write "\n"
        end
      end
    end

  end # class CsvMatchWriter






datafiles = Dir["./dl/fbref/**/*csv"]
puts "#{datafiles.size} datafiles"

datafiles.each do |datafile|

# sample datfile format style:
#    Wk,Day,Date,Time,Home,Score,Away,Attendance,Venue,Referee,Match Report,Notes
#    1,Sat,2010-08-14,,Bolton,0–0,Fulham,,,,Match Report,
#    1,Sat,2010-08-14,,Wigan Athletic,0–4,Blackpool,,,,Match Report,

    basename = File.basename( datafile, File.extname( datafile) )
    dirname  = File.basename( File.dirname( datafile ))

    puts "#{dirname}/#{basename}: (#{datafile})"
    rows = CsvHash.read( datafile, :header_converters => :symbol )

    ## convert to records
    recs = []
    rows.each do |row|
#    Wk,Day,Date,Time,Home,Score,Away,Attendance,Venue,Referee,Match Report,Notes
#    1,Sat,2010-08-14,,Bolton,0–0,Fulham,,,,Match Report,
       next if row[:home].empty? && row[:away].empty?   # skip empty "filler" rows

       ## note: replace unicode "fancy" dash with ascii-dash
       #  check other columns too - possible in teams?
       row[:score] = row[:score].gsub( /[–]/, '-' )


       values = []

       values << row[:wk]                  # matchday
       values << Date.strptime( row[:date], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' )   # e.g. Sat Aug 7 1993
       values <<  if row[:time].empty?     # time
                       '?'
                  else
                    ## e.g. 15:00 (16:00)  remove own time (only use local to venue)
                    #   note: use non-greedy (minimal) match e.g. .+?
                      row[:time].gsub( /\(.+?\)/, '' ).strip
                  end
        values << row[:home]    # team 1
        values << row[:score]   # ft
        values <<   if row[:score].empty?   # assume match still in future
                      ''
                    else
                      '?'          # ht
                    end
        values << row[:away]    # team 2


       recs << values
    end
    puts "  #{recs.size} records  (from #{rows.size} rows)"

    out_root = "../../../footballcsv/cache.leagues"
    # out_root = "./o"

    out_path = "#{out_root}/#{dirname}/#{basename}.csv"
    CsvMatchWriter.write( out_path, recs )
end




puts "bye"