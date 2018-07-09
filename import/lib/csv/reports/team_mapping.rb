# encoding: utf-8


class TeamMappingReport    ## change to TeamMapping(s)Part/Block/Partial/Builder or something - why? why not?


def initialize
  # do nothing for now
end


def build( team_names )

  canonical_teams =  SportDb::Import.config.teams


  ## show list of teams without known canoncial/pretty print name
  missing_names = []

  team_names.each do |team_name|
    missing_names << team_name     if canonical_teams[team_name].nil?
  end

  buf = ''

  if missing_names.size > 0
    missing_names = missing_names.sort   ## sort from a-z

    buf << "#{missing_teams.size} missing / unknown / (???) teams:\n"
    buf << "#{missing_names.join(', ')}\n"
    buf << "\n\n"

    ############################
    ## for easy update add cut-n-paste code snippet
    buf << "```\n"
    missing_names.each do |team_name|
      buf << ("%-22s =>\n" % team_name)
    end
    buf << "```\n\n"
  end



  buf << "\n\n"
  buf << "```\n"

  team_names.each do |team_name|
    team = canonical_teams[team_name]
    if team
       alt_team_names =  team.alt_names

       buf << ('%-26s  ' % team_name)
       if alt_team_names.nil?
         ## do (print) nothing
       elsif alt_team_names.size == 1
         buf << "=> #{alt_team_names[0]}"
       elsif alt_team_names.size > 1
         ## sort by lenght (smallest first)
         alt_team_names_sorted = alt_team_names.sort { |l,r| l.length <=> r.length }
         buf << "=> (#{alt_team_names.size}) #{alt_team_names_sorted.join(' • ')}"
       else
         ## canonical name is mapping name - do not repeat/print for now
       end
    else
       buf << " x #{team_name} (???)"
    end
    buf << "\n"
  end
  buf << "```\n\n"

  buf
end

end # class TeamMappingReport
