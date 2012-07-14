class Person
  def initialize(name)
    @name = name
  end

  def to_s
    "Person with name #{@name}"
  end
end

mike = Person.new('Mike')
puts mike