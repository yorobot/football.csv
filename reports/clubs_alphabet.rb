

module TeamIndexer


class TeamAlphabetPart

def initialize( teams )
  @teams = teams
end


## name (sanitize) helpers
def strip_year( name ) SportDb::Import::Club.strip_year( name ); end
def strip_lang( name ) SportDb::Import::Club.strip_lang( name ); end


def build   ## todo/check: always use render as name - why? why not?
  freq = Hash.new(0)

  @teams.each do |team|

    names = [team.name]+team.alt_names
    names.each do |name|
      ## calculate the frequency table of letters, digits, etc.
      name = strip_year( name )   ## e.g. FC Linz (1946-2001) => FC Linz
      name = strip_lang( name )   ## e.g. Bayern Munich [en] => Bayern Munich
      name.each_char do |ch|
         next if ch =~ /[A-Za-z0-9]/
         next if ch =~ /[.&',º()\/\- ]/  ## skip dot(.), &, dash(-), etc.

         freq[ch] += 1
      end
    end
  end

  pp freq

  sorted_freq = freq.to_a.sort do |l,r|
    res = l[0] <=> r[0]
    res
  end

  pp sorted_freq


  buf = String.new

  buf << "- **Alphabet Specials**"
  buf << " (#{sorted_freq.size})"
  buf << ": "
  sorted_freq.each do |rec|
    ch = rec[0]
    buf << " **#{ch}** "
  end
  buf << "\n"

  sorted_freq.each do |rec|
    ch    = rec[0]   ## character
    count = rec[1]   ## frequency count

    buf << "  - **#{ch}**×#{count} #{'U+%04X' % ch.ord} (#{ch.ord}) - #{Unicode::Name.of(ch)}"

    ## add char mappings
    sub    = Alphabet::UNACCENT[ ch ]
    sub_de = Alphabet::UNACCENT_DE[ ch ]
    buf << " ⇒ #{ sub || '**?**' }"
    if sub_de && sub_de != sub    ## e.g. ß is always ss (don't print duplicates)
      buf << "•#{sub_de}"
    end

    buf << "\n"
  end

  buf << "\n\n"
  buf
end  # method build

alias_method :render, :build

end # class TeamAlphabetPart


class TeamAlphabetByCountryPart

def initialize( teams )
  @teams = teams
end

## name (sanitize) helpers
def strip_year( name ) SportDb::Import::Club.strip_year( name ); end
def strip_lang( name ) SportDb::Import::Club.strip_lang( name ); end

def build   ## todo/check: always use render as name - why? why not?
  freq_by_country = {}

  @teams.each do |team|
    freq = freq_by_country[ team.country.key ] ||= Hash.new(0)

    names = [team.name]+team.alt_names
    names.each do |name|
      ## calculate the frequency table of letters, digits, etc.
      name = strip_year( name )   ## e.g. FC Linz (1946-2001) => FC Linz
      name = strip_lang( name )   ## e.g. Bayern Munich [en] => Bayern Munich
      name.each_char do |ch|
         next if ch =~ /[A-Za-z0-9]/
         next if ch =~ /[.&',º()\/\- ]/  ## skip dot(.), &, dash(-), etc.

         freq[ch] += 1
      end
    end
  end

  freq_by_ch = {}
  freq_by_country.each do |country_key,freq|
    freq.each do |ch,count|
       rec = freq_by_ch[ ch ] ||= [0,[]]
       rec[0] += count   ## first entry is total
       rec[1] << [country_key,count]         ## second is country list w/ count
    end
  end


  ###################################################
  # part i) print by characters / letters with country usage first
  buf = String.new

  sorted_freq = freq_by_ch.to_a.sort do |l,r|
    res = l[0] <=> r[0]
    res
  end

  buf << "- **Alphabet Specials**"
  buf << " (#{sorted_freq.size})"
  buf << ": "
  sorted_freq.each do |rec|
    ch = rec[0]
    buf << " **#{ch}** "
  end
  buf << "\n"

  sorted_freq.each do |rec|
    ch    = rec[0]
    count = rec[1][0]
    stats = rec[1][1]

    buf << "  - **#{ch}**×#{count} #{'U+%04X' % ch.ord} (#{ch.ord}) - #{Unicode::Name.of(ch)}"
    ## add char mappings
    sub    = Alphabet::UNACCENT[ ch ]
    sub_de = Alphabet::UNACCENT_DE[ ch ]
    buf << " ⇒ #{ sub || '**?**' }"
    if sub_de && sub_de != sub    ## e.g. ß is always ss (don't print duplicates)
      buf << "•#{sub_de}"
    end

    buf << " (#{stats.size}): "

    stats.each do |stat|
      country_key   = stat[0]
      country_count = stat[1]
      country = SportDb::Import.config.countries[ country_key ]
      ## note: markdown hack - add <!-- --> comment to "break" between ** and count
      buf << " **#{country.key} (#{country.name})**<!-- -->×#{country_count}"
    end

    buf << "\n"
  end

  buf << "\n\n"

  #########################
  #  print part ii

  buf << "By Country\n"
  buf << "\n\n"

  freq_by_country.each do |country_key,freq|

    country = SportDb::Import.config.countries[ country_key ]

    sorted_freq = freq.to_a.sort do |l,r|
      res = l[0] <=> r[0]
      res
    end

    buf << "- **#{country.key} (#{country.name})**: "
    buf << " (#{sorted_freq.size})"

    if sorted_freq.size > 0
      sorted_freq.each do |rec|
        ch    = rec[0]
        buf << " **#{ch}**"
      end

      buf << ": "

      sorted_freq.each do |rec|
        ch    = rec[0]
        count = rec[1]   ## frequency count
        buf << " **#{ch}**×#{count} #{'U+%04X' % ch.ord} (#{ch.ord}) "
      end
    end
    buf << "\n"
  end

  buf << "\n\n"
  buf
end  # method build

alias_method :render, :build

end # class TeamAlphabetByCountryPart

end # module TeamIndexer
