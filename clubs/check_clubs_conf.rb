
require_relative '../lint/check_clubs'




CONF_PATTERN = %r{
                  /\.conf\.txt$
                 }x

datafiles = find_datafiles( '../../../openfootball/austria', CONF_PATTERN )
pp datafiles


datafiles.each do |datafile|
  leagues = ConfClubLintReader.read( datafile )
  pp leagues
end
