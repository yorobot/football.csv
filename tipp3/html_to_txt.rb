require 'pp'
require 'nokogiri'



require_relative 'programs'



def assert( cond, msg )
  if cond
    # do nothing
  else
    puts "!!! assert failed - #{msg}"
    exit 1
  end
end



def parse_tipp3( html )
  recs = []

  doc = Nokogiri::HTML.fragment( html )   ## note: use a fragment NOT a document

  tbody = doc.css( 'table tbody' ).first    ## get table body (tbody)
  ## trs = tbody.search( 'tr' )   ## exclude last detailRow w/ 'tr.even, tr.odd' - why? why not?
  ##  note: only select immediate (  try if < works !!!)
  trs = tbody.children.select {|el| el.matches?('tr') && !el.matches?( '.detailRow' ) }
  puts trs.size
  puts tbody.css( 'tr' ).size



  trs.each_with_index do |tr,i|
    tds = tr.css( 'td' )

#  <td class="first nr">
#      <span>001</span>
#  </td>
    el  = tds.css( '.nr' )[0]    ## first
    assert( el, "no td.nr found" )

    nr = el.text.strip

#  <td class="time">
#      <span class="hiddenSortVal">1566905400000</span>
#      <span>27.08. 13:30</span>
#  </td>
    el  = tds.css( '.time' )[0]
    assert( el, "no td.time found" )

    el.css( 'span.hiddenSortVal').remove   ## note: delete hidden span
    time = el.text.strip

#  <td class="liga" title="Fussball - AFC Champions League">
#      <span class="hiddenSortVal">99170</span>
#             AFC CL
#  </td>

    el  = tds.css( '.liga' )[0]
    assert( el, "no td.liga found" )

    el.css( 'span.hiddenSortVal').remove   ## note: delete hidden span

    liga_title = el.attributes['title'].value.strip
    liga       = el.text.strip

   ## note: remove possible commas in liga title
   ##   step 1) replace with space
   ##   step 2) replace all multi-spaces with a single space
   ##  e.g. Fussball - Rumänien, Liga 2
   ##                 =>
   ##       Fussball - Rumänien Liga 2
   ## liga_title = liga_title.gsub( ',', ' ' )
   liga_title = liga_title.gsub( /[ ]+/, ' ' ).strip


#  <td class="players" title="Fussball - AFC Champions League">
#      SIPG Shanghai CHN
#  </td>
#  <td class="players" title="Fussball - AFC Champions League">
#      Urawa RD JPN
#  </td>

    players = []
    els = tds.css( '.players' )
    assert( els && els.size==2, "no td.players found or td.players.size != 2" )

    els.each do |el|
      player = el.text.strip

      # note: for now remove comma from names (used in tennis, for example):
      #  Fabbiano, Thomas   => Fabbiano Thomas
      #  Thiem, Dominic     => Thiem Dominic
      # player = player.gsub( ',', ' ' )
      player = player.gsub( /[ ]+/, ' ' ).strip

      players << player
    end


    el  = tds.css( '.stats' )[0]
    assert( el, "no td.stats found" )
    stats = el.text.strip

    el  = tds.css( '.score' )[0]
    assert( el, "no td.score found" )
    score = el.text.strip

    ## next if i > 5

    puts "#{i+1} | >#{nr}< >#{time}< >#{liga}< >#{liga_title}< >#{players[0]}< >#{players[1]}< >#{stats}< >#{score}<"
    recs << [nr, time, liga, players[0], score, players[1], stats, liga_title]
  end
  recs
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



PROGRAMS.each do |program|
   html = File.open( "dl/2019-#{program}.html", 'r:utf-8' ).read
   ## pp html
   recs = parse_tipp3( html )
   ##  sort by num (1st record filed e.g. 001, 002, 003, etc. - is sometimes out of order (and sorted by date))
   recs = recs.sort_by {|rec| rec[0]}
   pp recs
   save_tipp3( "2019-#{program}.csv", recs )
end
