
require_relative '../lint/check_chars'



datafiles = Datafile.find_conf( '../../../openfootball/austria' )
# datafiles = find_datafiles( '../../../openfootball/deutschland', CONF_PATTERN )
# datafiles = find_datafiles( '../../../openfootball/england', CONF_PATTERN )
pp datafiles

datafiles.each do |datafile|
   CharLinter.read( datafile )    ## check for non-ascii chars, tabs, etc.
   # CharLinter.fix( datafile )
end
