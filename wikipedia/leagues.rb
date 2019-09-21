require 'wikiscript'


# basename = '2018-19_Austrian_Football_Bundesliga'
basename = '2019-20_Austrian_Football_Bundesliga'

page = Wikiscript::PageReader.read( "pages/en/#{basename}.txt" )
pp page
