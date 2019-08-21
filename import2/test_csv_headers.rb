require 'csvreader'



path = "./sportdb-source-footballdata/dl"

datafiles = Dir.glob( "#{path}/**/*.csv" )
pp datafiles
pp datafiles.size   ## 570 datafiles

## used by main leagues
required_i = ['Date',
              'HomeTeam',
              'AwayTeam',
              'FTHG',
              'FTAG'
             ]

## used by Greece (G1)
required_ii = ['Date',
               'HT',
               'AT',
               'FTHG',
               'FTAG'
             ]
## used by extra leagues (ARG, AUT, ...)
required_iii = ['Date',
                'Home',
                'Away',
                'HG',
                'AG'
               ]

fields = [   'Date',
             'Time',
              'HomeTeam',  'HT', 'Home',
              'AwayTeam',  'AT', 'Away',
              'FTHG', 'HG',
              'FTAG', 'AG',
              'HTHG',
              'HTAG']

bet_fields_raw = <<TXT
B365H = Bet365 home win odds
B365D = Bet365 draw odds
B365A = Bet365 away win odds
B365CH
B365CD
B365CA
B365C>2.5
B365C<2.5
B365CAHH
B365CAHA

BSH = Blue Square home win odds
BSD = Blue Square draw odds
BSA = Blue Square away win odds
BWH = Bet&Win home win odds
BWD = Bet&Win draw odds
BWA = Bet&Win away win odds
GBH = Gamebookers home win odds
GBD = Gamebookers draw odds
GBA = Gamebookers away win odds
IWH = Interwetten home win odds
IWD = Interwetten draw odds
IWA = Interwetten away win odds
LBH = Ladbrokes home win odds
LBD = Ladbrokes draw odds
LBA = Ladbrokes away win odds

PSH = Pinnacle home win odds
PH
PSD = Pinnacle draw odds
PD
PSA = Pinnacle away win odds
PA

SOH = Sporting Odds home win odds
SOD = Sporting Odds draw odds
SOA = Sporting Odds away win odds
SBH = Sportingbet home win odds
SBD = Sportingbet draw odds
SBA = Sportingbet away win odds
SJH = Stan James home win odds
SJD = Stan James draw odds
SJA = Stan James away win odds
SYH = Stanleybet home win odds
SYD = Stanleybet draw odds
SYA = Stanleybet away win odds
VCH = VC Bet home win odds
VCD = VC Bet draw odds
VCA = VC Bet away win odds
WHH = William Hill home win odds
WHD = William Hill draw odds
WHA = William Hill away win odds

Bb1X2 = Number of BetBrain bookmakers used to calculate match odds averages and maximums
BbMxH = Betbrain maximum home win odds
BbAvH = Betbrain average home win odds
BbMxD = Betbrain maximum draw odds
BbAvD = Betbrain average draw win odds
BbMxA = Betbrain maximum away win odds
BbAvA = Betbrain average away win odds

MaxH = Oddsportal maximum home win odds
MaxD = Oddsportal maximum draw win odds
MaxA = Oddsportal maximum away win odds

AvgH = Oddsportal average home win odds
AvgD = Oddsportal average draw win odds
AvgA = Oddsportal average away win odds



# Key to total goals betting odds:

BbOU = Number of BetBrain bookmakers used to calculate over/under 2.5 goals (total goals) averages and maximums
BbMx>2.5 = Betbrain maximum over 2.5 goals
BbAv>2.5 = Betbrain average over 2.5 goals
BbMx<2.5 = Betbrain maximum under 2.5 goals
BbAv<2.5 = Betbrain average under 2.5 goals

GB>2.5 = Gamebookers over 2.5 goals
GB<2.5 = Gamebookers under 2.5 goals
B365>2.5 = Bet365 over 2.5 goals
B365<2.5 = Bet365 under 2.5 goals
P>2.5 = Pinnacle over 2.5 goals
P<2.5 = Pinnacle under 2.5 goals
Max>2.5 = Oddsportal maximum over 2.5 goals
Max<2.5 = Oddsportal maximum under 2.5 goals
Avg>2.5 = Oddsportal average over 2.5 goals
Avg<2.5 = Oddsportal average under 2.5 goals



# Key to Asian handicap betting odds:

BbAH = Number of BetBrain bookmakers used to Asian handicap averages and maximums
BbAHh = Betbrain size of handicap (home team)
AHh = Oddsportal size of handicap (home team) (since 2019/2020)
BbMxAHH = Betbrain maximum Asian handicap home team odds
BbAvAHH = Betbrain average Asian handicap home team odds
BbMxAHA = Betbrain maximum Asian handicap away team odds
BbAvAHA = Betbrain average Asian handicap away team odds

GBAHH = Gamebookers Asian handicap home team odds
GBAHA = Gamebookers Asian handicap away team odds
GBAH = Gamebookers size of handicap (home team)
LBAHH = Ladbrokes Asian handicap home team odds
LBAHA = Ladbrokes Asian handicap away team odds
LBAH = Ladbrokes size of handicap (home team)
B365AHH = Bet365 Asian handicap home team odds
B365AHA = Bet365 Asian handicap away team odds
B365AH = Bet365 size of handicap (home team)
PAHH = Pinnacle Asian handicap home team odds
PAHA = Pinnacle Asian handicap away team odds
MaxAHH = Oddsportal maximum Asian handicap home team odds
MaxAHA = Oddsportal maximum Asian handicap away team odds
AvgAHH = Oddsportal average Asian handicap home team odds
AvgAHA = Oddsportal average Asian handicap away team odds


#####################
# More

BWCH
BWCD
BWCA

IWCH
IWCD
IWCA

WHCH
WHCD
WHCA

VCCH
VCCD
VCCA

MaxCH
MaxCD
MaxCA
MaxC>2.5
MaxC<2.5
MaxCAHH
MaxCAHA

AvgCH
AvgCD
AvgCA
AvgC>2.5
AvgC<2.5
AvgCAHH
AvgCAHA

PC>2.5
PC<2.5
PCAHH
PCAHA

AHCh

PSCH
PSCD
PSCA

LB
TXT



def parse_bet_fields( bet_fields_raw )
  fields = []

  bet_fields_raw.each_line do |line|
      line = line.strip
      next if line.empty?
      next if line.start_with?( '#' )

      values = line.split('=')

      fields << values[0].strip
  end

  ## downcase fields too
  fields = fields.map { |field| field.downcase }
  fields
end


bet_fields = parse_bet_fields( bet_fields_raw )

pp bet_fields


stats = Hash.new(0)
all   = Hash.new(0)


def find_missing( header, required )
  missing = []
  required.each do |r|
      missing << r     unless header.include?(r)
  end
  missing
end



datafiles.each_with_index do |datafile,i|
  header = Csv.header( datafile )
  ## pp header

  fields.each do |f|
    stats[f] += 1   if header.include?(f)
  end

  header.each do |h|
    next   if bet_fields.include?(h.downcase)   ## skip known bet (odds) fields
    all[h] += 1
  end

  missing_i  = find_missing( header, required_i )
  if missing_i.size > 0
    ## try 2nd format
    missing_ii = find_missing( header, required_ii )
    if missing_ii.size > 0
      ## try 3rd format
      missing_iii = find_missing( header, required_iii )
      if missing_iii.size > 0
        puts
        puts "datafile #{i}/#{datafiles.size}: #{datafile} - missing headers:"
        pp missing_i
        pp missing_ii
        pp missing_iii
        pp header
      else
        print "3"
      end
    else
      print "2"
      ## print "2 (#{datafile})"
    end
  else
    print "1"
  end


  ## break if i > 250
end

puts "field usage stats:"
pp stats

=begin
{"Date"=>570,
 "Time"=>35,
 "HomeTeam"=>549, "HT"=>5, "Home"=>16,
 "AwayTeam"=>549, "AT"=>5, "Away"=>16,
 "FTHG"=>554,  "HG"=>16,
 "FTAG"=>554,  "AG"=>16,
 "HTHG"=>488,
 "HTAG"=>488 }
=end

puts

pp all
