

def load_matches( path_in )

  csv = CSV.read( path_in, headers: true )

  matches = []

  csv.each_with_index do |row,i|
    matches << Match.new.from_csv( row )
  end

  matches
end
