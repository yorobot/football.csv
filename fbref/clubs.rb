## check clubs

require 'csvreader'



clubs = Hash.new( 0 )    ## track club names & match count


## todo/fix: rename en.1.csv to eng!! eng.1.csv

recs = CsvHash.read( "2019-20/cl.csv", :header_converters => :symbol )
pp recs.size
pp recs[0]


recs.each do |rec|
  team1 = rec[:home]
  team2 = rec[:away]

  next if team1.empty? && team2.empty?   ## skip empty records / lines

  ## if international - normalize country code ( move two-or-three letter to back)
  ##  e.g. at, be, eng (!), etc.
  team2 = "#{team2[3..-1]} #{team2[0..2]}".strip

  names = [ team1, team2 ]
  names.each do |name|
    clubs[ name ] += 1
  end
end


pp clubs


sorted_clubs = clubs.to_a.sort do |l,r|
  ## sort by 1) counter 2) name a-z
  res = r[1] <=> l[1]
  res = l[0] <=> r[0]     if res == 0
  res
end


## fix/todo !!! mark unknown clubsseason
puts "sorted clubs (#{sorted_clubs.size}):"
sorted_clubs.each do |l|
  puts "   #{'%3s'%l[1]} #{l[0]}"
end

__END__

sorted clubs (12):
    22 Admira
    22 Austria Wien
    22 Hartberg
    22 LASK Linz
    22 Mattersburg
    22 RB Salzburg
    22 Rapid Wien
    22 SCR Altach
    22 St. Pölten
    22 Sturm Graz
    22 WSG Wattens
    22 Wolfsberger AC

sorted clubs (20):
    38 Arsenal
    38 Aston Villa
    38 Bournemouth
    38 Brighton
    38 Burnley
    38 Chelsea
    38 Crystal Palace
    38 Everton
    38 Leicester City
    38 Liverpool
    38 Manchester City
    38 Manchester Utd
    38 Newcastle Utd
    38 Norwich City
    38 Sheffield Utd
    38 Southampton
    38 Tottenham
    38 Watford
    38 West Ham
    38 Wolves

sorted clubs (32):
     6 Ajax nl
     6 Atalanta it
     6 Atlético Madrid es
     6 Barcelona es
     6 Bayer de
     6 Bayern Munich de
     6 Benfica pt
     6 Chelsea eng
     6 Club Brugge be
     6 Dinamo Zagreb hr
     6 Dortmund de
     6 Galatasaray tr
     6 Genk be
     6 Inter it
     6 Juventus it
     6 Lille fr
     6 Liverpool eng
     6 Loko Moscow ru
     6 Lyon fr
     6 Manchester City eng
     6 Napoli it
     6 Olympiacos gr
     6 Paris S-G fr
     6 RB Leipzig de
     6 RB Salzburg at
     6 Real Madrid es
     6 Red Star rs
     6 Shakhtar ua
     6 Slavia Prague cz
     6 Tottenham eng
     6 Valencia es
     6 Zenit ru
