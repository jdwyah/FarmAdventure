class Animal
  attr_reader :cost, :name, :day_bought, :type
  def initialize(cost:, name:, day_bought:, type: )
    @cost = cost
    @name = name
    @day_bought = day_bought
    @type = type
  end

  def print (today)
    "#{@type} named #{@name} age: #{today-@day_bought}"
  end
end
