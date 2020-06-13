# encoding: UTF-8

module SportDb

  class AutoFiller

    include Logging         ## e.g. logger#debug, logger#info, etc.
    include ParserHelper    ## e.g. read_lines, etc.


    def initialize( txt )
      @txt = txt
    end

  ## note: skip "decorative" only heading e.g. ========
  ##  todo/check:  find a better name e.g. HEADING_EMPTY_RE or HEADING_LINE_RE or ???
  HEADING_BLANK_RE = %r{\A
                        ={1,}
                        \z}x

  ## note: like in wikimedia markup (and markdown) all optional trailing ==== too
  HEADING_RE = %r{\A
                  (?<marker>={1,})       ## 1. leading ======
                    [ ]*
                  (?<text>[^=]+)         ## 2. text   (note: for now no "inline" = allowed)
                    [ ]*
                    =*                   ## 3. (optional) trailing ====
                  \z}x

  ## split into league + season
  ##  e.g. Österr. Bundesliga 2015/16   ## or 2015-16
  ##       World Cup 2018
  LEAGUE_SEASON_HEADING_RE =  %r{^
       (?<league>.+?)     ## non-greedy
         \s+
       (?<season>\d{4}
          (?:[\/-]\d{1,4})?     ## optional 2nd year in season
        )
        $}x


    def autofill  ## return new text (and change log??)
      buf = ''
      changelog = []   ## track changes  - rename - use edits? changes? etc.
      lineno = 0

      league = nil
      season = nil
      start  = nil

      event_rec = nil

      ###
      ## todo/check/fix:  move to LeagueOutlineReader for (re)use - why? why not?
      ##                    use sec[:lang] or something?
      langs = {    ## map country keys to lang codes
        'de' => 'de', ## de - Deutsch (German)
        'at' => 'de',
        'fr' => 'fr', ## fr - French
        'it' => 'it', ## it - Italian
        'es' => 'es', ## es - Español (Spanish)
        'mx' => 'es',
        'pt' => 'pt', ## pt -  Português (Portuguese)
        'br' => 'br'
      }


      @txt.each_line do |line|
        linesrc = line          ## note: incl. trailing newline!!
        line    = line.strip    ## note: strip leading and trailing whitespaces
        lineno +=1


        if line.start_with?( '#' )
          logger.debug "[#{'%03d' % lineno}] add comment line >#{line}<"
        elsif line.empty?
          logger.debug "[#{'%03d' % lineno}] add blank line >#{line}<"
        else
          ##
          ## strip inline (until end-of-line) comments too
          ##  e.g Eupen | KAS Eupen ## [de]
          ##   => Eupen | KAS Eupen
          ##  e.g bq   Bonaire,  BOE        # CONCACAF
          ##   => bq   Bonaire,  BOE
          line = line.sub( /#.*/, '' ).strip

          if HEADING_BLANK_RE.match( line )  # skip "decorative" only heading e.g. ========
            logger.debug "[#{'%03d' % lineno}] add blank heading line >#{line}<"

          elsif m=HEADING_RE.match( line )
            logger.debug "[#{'%03d' % lineno}] add heading line >#{line}<"

            heading_marker = m[:marker]
            heading_level  = m[:marker].length   ## count number of = for heading level
            heading        = m[:text].strip

            puts "heading #{heading_level} >#{heading}<"

            values = split_league( heading )
            if m=values[0].match( LEAGUE_SEASON_HEADING_RE )
              league_q = m[:league]
              season_q = m[:season]

              puts "league >#{league_q}<, season >#{season_q}<"

              season = Import::Season.new( season_q )
              league = catalog.leagues.find!( league_q )
              pp season
              pp league

              event_rec = Sync::Event.find_by!( league: league,
                                                season: season )
              pp event_rec

              ## hack for now: switch lang
              ## todo/fix: set lang for now depending on league country!!!
              if league.intl?   ## todo/fix: add intl? to ActiveRecord league!!!
                Import.config.lang = 'en'
              else  ## assume national/domestic
                Import.config.lang = langs[ league.country.key ] || 'en'
              end

              start = if season.year?
                Date.new( season.start_year, 1, 1 )
              else
                Date.new( season.start_year, 7, 1 )
              end
            else
              puts "** !!! ERROR - cannot match league and season in heading; season missing?"
              pp heading
              exit 1
            end
          elsif is_goals?( line )
             logger.debug "[#{'%03d' % lineno}] add goals line: >#{line}<"
          elsif is_round_def?( line )
             logger.debug "[#{'%03d' % lineno}] add round def line: >#{line}<"
          elsif is_round?( line )
             logger.debug "[#{'%03d' % lineno}] add round line: >#{line}<"
          elsif is_group_def?( line ) ## NB: group goes after round (round may contain group marker too)
             logger.debug "[#{'%03d' % lineno}] add group def line: >#{line}<"
          elsif is_group?( line )
             logger.debug "[#{'%03d' % lineno}] add group line: >#{line}<"
          else
             teams, score = parse_match( line, start: start )

             if teams
               if score
                 logger.debug "[#{'%03d' % lineno}] add match line >#{line}<"
               else
                 ## try auto-fill / patch match line - found match line with missing score
                 logger.debug "[#{'%03d' % lineno}] !! auto-fill / patch match line >#{line}<"

                 team1 = catalog.teams.find_by!( name: teams[0], league: league )
                 team2 = catalog.teams.find_by!( name: teams[1], league: league )
                 # pp team1
                 # pp team2

                 team1_rec = Model::Team.find_by( name: team1.name )
                 team2_rec = Model::Team.find_by( name: team2.name )

                 match_rec =  if team1_rec && team2_rec
                                find_match( event_rec, team1_rec, team2_rec )
                              else
                                 puts "!! WARN - no team record(s) found in db; cannot lookup match"
                                 nil   # no match found (even possible)
                              end

                 if match_rec
                  if match_rec.score1 && match_rec.score2
                    ## pp match_rec
                    ## patch score
                    ##  use simple regex for now
                    linesrc = linesrc.sub( /[ ]{1,2}
                                            -
                                           [ ]{1,2}/x
                                        ) do |_|
                      m = Regexp.last_match    ## last match
                      old_score = m[0]
                      new_score = "  #{match_rec.score1}-#{match_rec.score2}  "
                      msg = "changing >#{old_score}< to >#{new_score}<"
                      puts msg

                      changelog << "line #{lineno} - #{msg}"
                      new_score
                   end
                 else
                   ## todo/check:  score might all be nil (not yet played; match in the future)
                   puts "!! WARN - score is nil for match for:"
                   pp score
                   pp teams
                 end
                else
                   puts "!! WARN - no match found for #{team1.name} - #{team2.name}"
                end
               end
              else  ## no two teams found; assume it's NOT a match line
               logger.debug "[#{'%03d' % lineno}] add line >#{line}<"
             end
          end
        end

        buf << linesrc
      end # each lines

      [buf, changelog]
    end # method autofill


#########
#   helpers



def find_match( event_rec, team1_rec, team2_rec )

  recs = Model::Match.where( event_id: event_rec.id,
                             team1_id: team1_rec.id,
                             team2_id: team2_rec.id ).to_a

  if recs.size > 1
    puts "!! ERROR - too many matches found for #{team1_rec.name} - #{team2_rec.name}; expected one - got #{recs.size}"
    exit 1
  end

  if recs.empty?
    nil
  else
    recs[0]    ## bingo!! if we get here - assume we got a match record
  end
end



def catalog() Import.catalog; end    ## shortcut convenience helper

def split_league( str )   ## todo/check: rename to parse_league(s) - why? why not?
  ## split into league / stage / ... e.g.
  ##  => Österr. Bundesliga 2018/19, Regular Season
  ##  => Österr. Bundesliga 2018/19, Championship Round
  ##  etc.
  values = str.split( /[,<>‹›]/ )  ## note: allow , > < or › ‹ for now
  values = values.map { |value| value.strip }   ## remove all whitespaces
  values
end


def find_score!( line )
  # note: always call after find_dates !!!
  #  scores match date-like patterns!!  e.g. 10-11  or 10:00 etc.
  #   -- note: score might have two digits too
  ScoreFormats.find!( line )
end

def find_date!( line, start: )
  ## NB: lets us pass in start_at/end_at date (for event)
  #   for auto-complete year

  # extract date from line
  # and return it
  # NB: side effect - removes date from line string
  DateFormats.find!( line, start: start )
end

def parse_match( line, start: )
  line = line.dup
  ## logger.debug "try parsing match line: >#{line}<"

  ## remove all protected text runs e.g. []
  ##   fix: add [ to end-of-line too
  ##  todo/fix: move remove protected text runs AFTER find date!! - why? why not?

  line = line.gsub( /\[
                      [^\]]+?
                     \]/x, '' ).strip
  return []  if line.empty?    ## note: return true (for valid line with no match/teams)


  ## split by geo (@) - remove for now
  values = line.split( '@' )
  line = values[0]


  ## try find date
  date = find_date!( line, start: start )
  if date   ## if found remove tagged run too; note using singular sub (NOT global gsub)
    line = line.sub( /\[
                        [^\]]+?
                       \]/x, '' ).strip

  else
    ##  check for leading hours only e.g.  20.30 or 20:30 or 20h30 or 20H30 or 09h00
    ##   todo/fix: make language dependent (or move to find_date/hour etc.) - why? why not?
    line = line.sub(  %r{^           ## MUST be anchored to beginning of line
                          [012]?[0-9]
                          [.:hH]
                          [0-9][0-9]
                         (?=[ ])    ## must be followed by space for now (add end of line too - why? why not?)
                        }x, '' ).strip
  end

  return []     if line.empty?    ## note: return true (for valid line with no match/teams)


  score = find_score!( line )

  logger.debug "  line: >#{line}<"

  line = line.sub( /\[
                      [^\]]+?
                     \]/x, '$$' )  # note: replace first score tag with $$
  line = line.gsub( /\[
                  [^\]]+?
                 \]/x, '' )    # note: replace/remove all other score tags with nothing

   ##  clean-up  remove all text run inside () or empty () too
   line = line.gsub( /\(
                   [^)]*?
                  \)/x, '' )


   ## check for more match separators e.g. - or vs for now
   line = line.sub( / \s+
                        (   -
                          | v
                          | vs\.?    # note: allow optional dot eg. vs.
                        )
                      \s+
                     /ix, '$$' )

   values = line.split( '$$' )
   values = values.map { |value| value.strip }        ## strip spaces
   values = values.select { |value| !value.empty? }   ## remove empty strings

   return []    if values.size == 0  ## note: return true (for valid line with no match/teams)

   if values.size == 1
     puts "(auto config) try matching teams separated by spaces (2+):"
     pp values

     values = values[0].split( /[ ]{2,}/ )
     pp values
   end

   return []   if values.size != 2

   ## return matched teams and score
   [values, score]
end



end # class AutoFiller
end # module SportDb
