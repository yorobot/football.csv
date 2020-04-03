# encoding: utf-8


module Footballdata

##
## todo/fix: add fix_date converter to CsvReader !!!!!



def self.convert_season_by_season( country_key, sources,
                                   in_dir:,
                                   out_dir:,
                                   start: nil,
                                   normalize: false )

  sources.each do |rec|
    season_key   = rec[0]   ## note: dirname is season e.g. 2011-12 etc.
    basenames    = rec[1]   ## e.g. E1,E2,etc.

    if start && SeasonUtils.start_year( season_key ) < SeasonUtils.start_year( start )
      puts "skip #{season_key} before #{start}"
      next
    end

    basenames.each do |basename|

      in_path = "#{in_dir}/#{season_key}/#{basename}.csv"

      league_key = FOOTBALLDATA_LEAGUES[basename]
      league_basename = league_key   ## e.g.: eng.1, fr.1, fr.2 etc.

      ## note: for de-deutschland, eng-england and es-espana
      ##   use long format e.g. 2010s/2011-12 etc
      if [:de, :eng, :es].include?( country_key )
        out_path = "#{out_dir}/#{SeasonUtils.directory(season_key, format: 'long')}/#{league_basename}.csv"
      else
        out_path = "#{out_dir}/#{SeasonUtils.directory(season_key)}/#{league_basename}.csv"
      end

      puts "in_path: #{in_path}, out_path: #{out_path}"
      ## CsvMatchConverter.convert( in_path, out_path )

      matches = CsvMatchReader.read( in_path )

      normalize_clubs( matches, country_key )  if normalize

      CsvMatchWriter.write( out_path, matches )
    end
  end
end # method convert_season_by_season



def self.convert_all_seasons( country_key, basename,
                                   in_dir:,
                                   out_dir:,
                                   start: nil,
                                   normalize: false )

  col  = 'Season'
  path = "#{in_dir}/#{basename}.csv"

  ## fix/todo: move find_seasons to CsvReader !!!!!!
  season_keys = CsvMatchSplitter.find_seasons( path, col: col )
  pp season_keys

  ## todo/check: make sure timezones entry for country_key exists!!! what results with nil/24.0 ??
  fix_date_converter = ->(row) { fix_date( row, FOOTBALLDATA_TIMEZONES[country_key]/24.0 ) }

  season_keys.each do |season_key|

    if start && SeasonUtils.start_year( season_key ) < SeasonUtils.start_year( start )
      puts "skip #{season_key} before #{start}"
      next
    end

    matches = CsvMatchReader.read( path, filters: { col => season_key },
                                         converters: fix_date_converter )

    pp matches[0..2]
    pp matches.size

    ## note: assume (always) first level league for now
    league_basename = "#{country_key}.1"    ## e.g.: ar.1, at.1, mx.1, us.1, etc.

    out_path = "#{out_dir}/#{SeasonUtils.directory(season_key)}/#{league_basename}.csv"

    normalize_clubs( matches, country_key )  if normalize

    CsvMatchWriter.write( out_path, matches )
  end
end


####
#  helper for normalize clubs
def self.normalize_clubs( matches, country_key )
  country_key = country_key.to_s  ## note: club struct uses string (not symbols); make sure we (always) use strings (otherwise compare fails)
  cache = {}   ## note: use a (lookup) cache for matched club names

  country = SportDb::Import.config.countries[ country_key ]
  ## todo/fix: assert country NOT nil / present

  matches.each do |match|
    names = [match.team1, match.team2]
    clubs = []     # holds the match club 1 and club 2 (that is, team 1 and team 2)
    names.each do |name|
      club = cache[name]
      if club   ## bingo! found cached club match/entry
        clubs << club
      else
        club = SportDb::Import.config.clubs.find_by( name: name, country: country )
        if club.nil?
          ## todo/check: exit if no match - why? why not?
          puts "!!! *** ERROR *** no matching club found for >#{name}, #{country_key}< - add to clubs setup"
          exit 1
        end
        cache[name] = club   ## cache club match
        clubs << club        
      end
    end # each name
    ## update names to use canonical names
    match.update( team1: clubs[0].name,
                  team2: clubs[1].name )
  end # each match
end  # method normalize_clubs


end # module Footballdata
