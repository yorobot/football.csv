
require_relative '../lint/check_clubs'



RSSSF_RE = %r{
                  /[a-z]{2,3}.txt$
                 }x


File.open( 'missing_clubs.txt', 'w:utf-8' ) do |out|

datafiles = Datafile.find( '2018-19', RSSSF_RE )
datafiles.each do |datafile|

  nodes = SportDb::Import::ClubLintReader.read( datafile )
  pp nodes

  count = check_clubs_by_countries( nodes, out: out )
  pp count

  if count == 0
    puts "** OK"
  else
    puts "** !!! ERROR !!! #{count} club names missing"
  end
end
end  ## File.open
