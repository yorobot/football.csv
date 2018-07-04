# encoding: utf-8


def recalc_repo( repo )   ## repo e.g. eng-england
  pack = CsvPackage.new( repo, path: '../../footballcsv' )
  CsvStandingsWriter.new( pack ).write    ## use path e.g. './o/en' for debugging
end


task :engtables do |t|
  recalc_repo( 'eng-england' )
end # task :entables

task :detables do |t|
  recalc_repo( 'de-deutschland' )
end # task :entables

task :estables do |t|
  recalc_repo( 'es-espana' )
end # task :entables

task :ittables do |t|
  recalc_repo( 'it-italy' )
end # task :entables

task :frtables do |t|
  recalc_repo( 'fr-france' )
end # task :entables


task :betables do |t|
  recalc_repo( 'be-belgium' )
end # task :betables
