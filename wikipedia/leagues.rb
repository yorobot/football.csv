require 'wikiscript'


# basename = '2018-19_Austrian_Football_Bundesliga'
basename = '2019-20_Austrian_Football_Bundesliga'

nodes = Wikiscript.read( "pages/en/#{basename}.txt" ).parse
pp nodes

## note:  needs typographic (–) e.g. 2019–20 will NOT work with "plain" 2018-19
## page = Wikiscript.get( "2019–20_Austrian_Football_Bundesliga" )
## pp page
## pp page.parse
