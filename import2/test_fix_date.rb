##########################
#   test convert / fix timezone


=begin
Austria,Tipico Bundesliga,2019/2020,11/08/2019,16:00,Hartberg,Sturm Graz,1,0
Austria,Tipico Bundesliga,2019/2020,11/08/2019,16:00,Mattersburg,Austria Vienna,1,5
Austria,Tipico Bundesliga,2019/2020,11/08/2019,16:00,Tirol,St. Polten,1,1


Mexico,Liga MX,2019/2020,04/08/2019,03:06,Monterrey,Club Leon,3,2
Mexico,Liga MX,2019/2020,04/08/2019,18:00,U.N.A.M.- Pumas,U.A.N.L.- Tigres,0,1
Mexico,Liga MX,2019/2020,05/08/2019,01:00,Juarez,Toluca,2,0
Mexico,Liga MX,2019/2020,10/08/2019,01:00,Monarcas,Monterrey,0,1
Mexico,Liga MX,2019/2020,10/08/2019,03:00,Veracruz,Atlas,1,2
Mexico,Liga MX,2019/2020,10/08/2019,03:06,Club Tijuana,U.N.A.M.- Pumas,1,0
Mexico,Liga MX,2019/2020,10/08/2019,23:00,Cruz Azul,Juarez,2,0
Mexico,Liga MX,2019/2020,10/08/2019,23:00,Queretaro,Pachuca,2,1
Mexico,Liga MX,2019/2020,11/08/2019,01:00,U.A.N.L.- Tigres,Necaxa,3,1
Mexico,Liga MX,2019/2020,11/08/2019,03:05,Guadalajara Chivas,Atl. San Luis,3,0
Mexico,Liga MX,2019/2020,11/08/2019,18:00,Toluca,Club America,0,1
Mexico,Liga MX,2019/2020,12/08/2019,00:45,Santos Laguna,Puebla,4,1
=end


require 'pp'
require 'date'
require 'time'


# https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
##  todo/fix: add support for dst (daylight saving time!!! )
##   uses always "winter" time for now
TIMEZONES = {
  mx:  -6,     ## America/Mexico_City - note: baja sur is -7, bajar norte (tijuana) is -8 !!!
  us:  -5,     ## America/New_York
  ar:  -3,     ## America/Argentina/Buenos_Aires
  br:  -3,     ## America/Sao_Paulo

  eng:  0,     ## Europe/London
  sco:  0,     ## ?
  ie:   0,     ## Europe/Dublin
  pt:   0,     ## Europe/Lisbon
  at:  +1,     ## Europe/Vienna
  de:  +1,     ## Europe/Berlin
  it:  +1,     ## Europe/Rome
  es:  +1,     ## Europe/Madrid
  fr:  +1,     ## Europe/Paris
  nl:  +1,     ## Europe/Amsterdam
  be:  +1,     ## Europe/Brussels
  dk:  +1,     ## Europe/Copenhagen
  no:  +1,     ## Europe/Oslo
  se:  +1,     ## Europe/Stockholm
  ch:  +1,     ## Europe/Zurich

  fi:  +2,     ## Europe/Helsinki
  gr:  +2,     ## Europe/Athens
  pl:  +2,     ## Europe/Warsaw
  ro:  +2,     ## Europe/Bucharest
  tr:  +3,     ## Europe/Istanbul
  ru:  +3,     ## Europe/Moscow

  cn:  +8,     ## Asia/Shanghai
  jp:  +9,     ## Asia/Tokyo
}



def fix_date( row, offset )
  return row    if row['Time'].nil?   ## note: time (column) required for fix

  col = row['Date']
  if col =~ /^\d{2}\/\d{2}\/\d{4}$/
    date_fmt = '%d/%m/%Y'   # e.g. 17/08/2002
  elsif col =~ /^\d{2}\/\d{2}\/\d{2}$/
    date_fmt = '%d/%m/%y'   # e.g. 17/08/02
  else
    puts "*** !!! wrong (unknown) date format >>#{col}<<; cannot continue; fix it; sorry"
    ## todo/fix: add to errors/warns list - why? why not?
    exit 1
  end

  date = DateTime.strptime( "#{row['Date']} #{row['Time']}", "#{date_fmt} %H:%M" )
  date = date + offset

  row['Date'] = date.strftime( date_fmt )  ## overwrite "old"
  row['Time'] = date.strftime( '%H:%M' )
  row   ## return row for possible pipelining - why? why not?
end

def run_converters( converters_or_converter, row )
  if converters_or_converter.is_a? Proc
    converters = [converters_or_converter]
  else  ## assumes Array of Procs
    converters = converters_or_converter
  end

  converters.each do |converter|
    row = converter.call( row )
  end

  row
end


row = {
  'Date' => '11/08/2019',
  'Time' => '16:00'
}

pp row
pp fix_date( row, TIMEZONES[:at]/24.0 )

fix_date_at = ->(row) { fix_date( row, TIMEZONES[:at]/24.0 ) }
pp fix_date_at.call( row )

pp run_converters( fix_date_at, row )
pp run_converters( [fix_date_at], row )
pp run_converters( [fix_date_at, fix_date_at], row )


row = {
  'Date' => '12/08/2019',
  'Time' => '00:45'
}

puts "---"

pp row
pp fix_date( row, TIMEZONES[:mx]/24.0 )
