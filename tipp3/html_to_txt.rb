require 'pp'
require 'nokogiri'



require_relative 'programs'

require_relative 'html_to_txt_i'
require_relative 'html_to_txt_ii'


def assert( cond, msg )
  if cond
    # do nothing
  else
    puts "!!! assert failed - #{msg}"
    exit 1
  end
end



def parse_tipp3( html )

  if html =~ %r{class="t3-list-entry}
    parse_tipp3_ii( html )
  else  ## assume old "classic" format (before 2020)
    parse_tipp3_i( html )
  end

end # parse_tipp3



def csv_encode( values )
  ## quote values that incl. a comma
  values.map do |value|
    if value.index(',')
      puts "** rec with field with comma:"
      pp values
      %Q{"#{value}"}
    else
      value
    end
  end.join( ',' )
end

def save_tipp3( path, recs )
  headers = ['Num','Date', 'Liga', 'Team 1', 'Score', 'Team 2', 'Result', 'Liga Title']
  File.open( path, 'w:utf-8' ) do |f|
    f.write headers.join( ',' )
    f.write "\n"
    recs.each do |rec|
      f.write csv_encode( rec )
      f.write "\n"
    end
  end
end



PROGRAMS_2020.each do |program|
   html = File.open( "dl/#{program}.html", 'r:utf-8' ).read
   ## pp html
   recs = parse_tipp3( html )
   ##  sort by num (1st record filed e.g. 001, 002, 003, etc. - is sometimes out of order (and sorted by date))
   recs = recs.sort_by {|rec| rec[0]}
   pp recs
   save_tipp3( "o/#{program}.csv", recs )
end
