# encoding: utf-8

require './import/lib/read'


path = './dl/engsoccerdata/data-raw/champs.csv'




###
## todo/fix: move to ScoreUtils.equal?  - why? why not?
##
def score_equal?( col, col1, col2 )
  col  = col.strip     # note: always remove leading and trailing spaces
  col1 = col1.strip
  col2 = col2.strip

  score1, score2 = (col.empty? || col == 'NA') ? [nil,nil] : col.split('-')

  exp_score1 = (col1.empty? || col1 == 'NA') ? nil : col1
  exp_score2 = (col2.empty? || col2 == 'NA') ? nil : col2


  (exp_score1 == score1 && exp_score2 == score2) ? true : false
end


values = {}

last_year = nil

i = 0
CSV.foreach( path, headers: true ) do |row|
  i += 1

  pp row    if i == 1

  print '.' if i % 100 == 0


  ### todo/fix: auto-add to all csv files!!!!!
  year = row['Season'].strip.to_i

  ### assert / validate order of records for (fast) splitting
  if last_year && last_year > year
    puts "\n\n*** !!!! ERROR: season out-of-order in row #{i}: #{row.inspect}"
    exit 1
  end

  values['pens'] ||= Hash.new(0)
  values['pens'][ row['pens'].strip ] +=1

  values['aet'] ||= Hash.new(0)
  values['aet'][ row['aet'].strip ] +=1

  values['FTagg_home'] ||= Hash.new(0)
  values['FTagg_home'][ row['FTagg_home'].strip ] +=1

  values['FTagg_visitor'] ||= Hash.new(0)
  values['FTagg_visitor'][ row['FTagg_visitor'].strip ] +=1

# "tothgoal","totvgoal"   -- what do they mean / what used for???
# "totagg_home","totagg_visitor"


  ############
  ## fix/todo:
  ##  make it a method for reuse!!!
  ##   to (double) check scores!!!

  ### check if aet and aethgoal/aetvgoal are equal
  if score_equal?( row['FT'], row['hgoal'], row['vgoal'] ) == false
    puts "\n\n** !!!! ERROR: score mismatch - FT <=> hgoal, vgoal:"
    pp row['FT']
    pp row['hgoal']
    pp row['vgoal']
    exit 1
  end

  if score_equal?( row['aet'], row['aethgoal'], row['aetvgoal'] ) == false
    puts "\n\n** !!!! ERROR: score mismatch aet <=> aethgoal, aetvgoal:"
    pp row['aet']
    pp row['aethgoal']
    pp row['aetvgoal']
    exit 1
  end


  last_year = year
end



pp values

puts "\nOK. Done. Bye."
