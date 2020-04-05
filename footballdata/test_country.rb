###
## ruby lang syntax test if country = country(country) works - yes, it does!

class Test

  def country( country )
    puts country
    puts country.class.name
    puts "<#{country}>"
  end

  def find_by( name:, country: )
    country = country( country )
    puts country
  end
end

Test.new.find_by( name: 'Arsenal', country: 'eng' )
