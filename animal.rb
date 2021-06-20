class Animal
  attr_reader :cost, :name, :day_bought, :type
  def initialize(cost:, name:, day_bought:, type: )
    @cost = cost
    @name = name
    @day_bought = day_bought
    @type = type
  end

  def to_s
    "#{@type} named #{@name}"
  end
end
