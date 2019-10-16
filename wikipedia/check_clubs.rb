
require_relative '../lint/check_clubs'




def check_clubs( recs )
  ## country = SportDb::Import::Country.new( 'at', 'Austria', fifa: 'AUT' )
  ## country = SportDb::Import::Country.new( 'ar', 'Argentina', fifa: 'ARG' )
  ## pp country

  recs.each do |rec|
    heading     = rec[0]

    country = COUNTRIES[ heading ]
    pp country
    if country.nil?
      puts "!!! error [club reader] - unknown country >#{heading}< in heading - sorry - add country to config to fix"
      exit 1
    end


    club_recs   = rec[1]
    club_recs.each do |club_rec|
      club_names  = club_rec[:names]

      ## check for missing club or missing (alternate) name
      ## check if all matches are the same club too!!!!
      clubs = []
      missing = []
      club_names.each do |name|
        club = find_club( name, country )
        if club
          clubs << club
        else
          missing << name
        end
      end

      ## check if found
      if clubs.empty?
        puts "!! club missing / not found any name (#{club_names.size}):"
        puts "    #{club_names.join(' | ')}"
      else
        ## check if clubs are the same (MUST be the same)
        uniq_clubs = clubs.uniq
        if uniq_clubs.size > 1
          puts "!! club names ambigious - matching #{uniq_clubs.size} clubs:"
          puts "    #{club_names.join(' | ')}"
          puts "    #{clubs.inspect}"
        end

        if missing.size > 0
          puts "!! #{missing.size} club (alternate) name(s) missing for >#{clubs[0].name} (#{clubs[0].alt_names.join(' | ')})< :"
          puts "    #{missing.join(' | ')}"
          puts "    #{club_names.join(' | ')}"
        end

        if missing.empty? && uniq_clubs.size == 1
          puts "OK   >#{club_names.join(' | ')}< (#{club_names.size}) matching >#{clubs[0].name}<"
        end
      end

    ## pp club_names
    end
  end
end


CLUBS_PATTERN = %r{
                  /[a-z]+\.clubs\.txt$
                 }x


# datafile = 'ar.clubs.txt'
# datafile = 'at.clubs.txt'
# datafile = 'conmebol.clubs.txt'
# datafile = 'uefa.clubs.txt'
# datafile = 'be.clubs.txt'
# datafile = 'nz.clubs.txt'
datafile = 'concacaf.clubs.txt'
recs = ClubLintReader.read( "./o/#{datafile}" )
pp recs

check_clubs( recs )


__END__

File.open( 'missing_clubs.txt', 'w:utf-8' ) do |out|

datafiles = find_datafiles( '.', CLUBS_PATTERN )
datafiles.each do |datafile|

  countries = ClubLintReader.read( datafile )
  pp countries

  missing_clubs = check_clubs_by_countries( countries )
  pp missing_clubs

  missing_clubs.each do |rec|
     if rec[1].empty?
        puts "** OK >#{rec[0]}<"
     else
        puts "** !!! ERROR !!! #{rec[1].size} club names missing >#{rec[0]}<"
        ## exit 1

        out.puts
        out.puts "=========="
        out.puts rec[0]
        out.puts
        rec[1].each do |name|
          out.puts name
        end
     end
  end
end
end  ## File.open
