# encoding: utf-8

## stdlibs
require 'json'
require 'pp'

## 3rd party libs/gems
require 'textutils'

## our own code
require './countries'
require './clubs'



MISSING_COUNTRIES = {}


def calc_age( today, birthdate )
   age = today.year - birthdate.year

   age -= 1   if today.month <  birthdate.month
   age -= 1   if today.month == birthdate.month && today.day < birthdate.day
   age
end


def gen_squad( club, h )
  buf = ''
  buf << "###########################\n"
  buf << "#  #{club}\n"
  buf << "\n"

  last_position = ''
  h.each do |(k,v)|
    num           = v['number']
    birthdate_str = v['birthdate']
    name          = k
    position      = v['position']
    country       = v['country']
    since         = v['since']

    birthdate = Date.strptime( birthdate_str, '%d.%m.%Y' )  ## e.g. assumes 01.01.1982
    
    today     = Date.new( 2015, 8, 31 )  ## use for age calc (start of season)
    age =  calc_age( today, birthdate )
    

    if num == 'xx'
      num = ''   # convert unknown number eg. xx to empty string
    end
    

    if country =~ /^[A-Z]{3}$/   ## three letter code use as is
      cc = country
    else
      cc  = COUNTRY_CODE[country]
      if cc.nil?
        puts "*** warn: no country code found for #{country}"
        if MISSING_COUNTRIES[country].nil?
          MISSING_COUNTRIES[country] = ''
        end
        cc = '???'
      end
    end

    if last_position != position
      buf << "\n"
    end

    buf << "%2s  " % num
    if cc == "GER"
      buf << "%-33s  " % name      ## do NOT include country code for "natives"
    else
      buf << "%-33s  " % ("#{name} (#{cc})")
    end

    buf << "%s  " % position
    buf << "%s-       " % since
    buf << "#  %11s (%s)"  % [birthdate.strftime( '%-d %b %Y' ), age]   ## e.g. reformat to 1 Jan 1984
    buf << "\n"
    
    last_position = position
  end
  buf
end



SORT_POSITION = {
  'GK' => 0,
  'DF' => 1,
  'MF' => 2,
  'FW' => 3,
}



def make_squads( clubs, opts={} )

  out_dir = opts[:out_dir]   ## e.g. './build/de-deutschland'

  clubs.each_with_index do |(k,v), i|
    club       = k
    club_key   = CLUB_KEY[ k ]
    players    = v

    players = players.sort do |l,r|
      ## note gets us an array e.g.
      ##   ["Osako, Yuya", {"birthdate"=>"18.05.1990", "country"=>"Japan", "number"=>"13", "position"=>"FW"}]
      ##  e.g. l[0] is the key; l[1] is the value e.g. hash
      lpos = l[1]['position']   
      rpos = r[1]['position']

      value =  SORT_POSITION[lpos] <=> SORT_POSITION[rpos]
      value =  l[1]['number'].to_i <=> r[1]['number'].to_i    if value == 0
      value
    end
    players = players.to_h  # "convert" it back (after sorting) into an hash
    ##  pp players
  
    puts "*** #{club}"
    
    out_path = "#{out_dir}/#{club_key}.txt"

    puts "#{club_key} - #{out_path}"
    txt = gen_squad( club, players )
    puts txt

    ## make sure out_path exists
    ## make sure dest folder exists
    FileUtils.mkdir_p( out_dir ) unless Dir.exists?( out_dir )
  
    File.open( out_path, 'w' ) do |f|
      f.write txt
    end
  end
end  # make_squads



################################
# let's go

de1 = JSON.parse( File.read_utf8( './de-deutschland/2015-16/1-bundesliga-squads.json' ))
de2 = JSON.parse( File.read_utf8( './de-deutschland/2015-16/2-bundesliga-squads.json' ))

## for debugging
## make_squads( de1, out_dir: './build/de-deutschland' )
## make_squads( de2, out_dir: './build/de-deutschland' )

make_squads( de1, out_dir: '../../openfootball/de-deutschland/2015-16/squads' )
make_squads( de2, out_dir: '../../openfootball/de-deutschland/2015-16/squads' )


pp MISSING_COUNTRIES

