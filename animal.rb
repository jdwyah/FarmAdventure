class Animal
  attr_reader :cost, :name, :day_bought, :type, :hunger_level

  TOO_HUNGRY_IM_DEAD = 5

  def initialize(cost:, name:, day_bought:, type: )
    @cost = cost
    @name = name
    @day_bought = day_bought
    @type = type
    @hunger_level = 0 # 0 is good 5 is dead
  end

  def print (today)
    "#{@type} named #{@name} age: #{today-@day_bought} hunger: #{@hunger_level}"
  end

  def feed
    # eat food
    @hunger_level -= 1
    puts "feeding cow"
  end

  def do_end_of_day_things
    if @hunger_level >= TOO_HUNGRY_IM_DEAD
      puts "!!!!!! #{@name} died of hunger!!!!!!!"
      return :died
    end

    # get hungry
    @hunger_level += 1
  end

end
