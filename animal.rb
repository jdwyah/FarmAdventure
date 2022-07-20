
using Rainbow
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
    "#{@type} named #{@name} age: #{age(today)} hunger: #{@hunger_level}"
  end

  def do_end_of_day_things
    if @hunger_level >= TOO_HUNGRY_IM_DEAD
      puts "!!!!!! #{@name} died of hunger!!!!!!!".red
      return :died
    end

    # get hungry
    @hunger_level += 1
  end


  def feed(wheat)
    if wheat > 0
      # eat food
      @hunger_level -= 1
      
      # eat an additional wheat if still hungry
      if @hunger_level > 0 
        wheat -= 1        
        @hunger_level -= 1
        puts "Your #{@type} #{@name} ate 2 wheat and is now less hungry."
        return 2
      else
        puts "Your #{@type} #{@name} ate 1 wheat."
        return 1
      end
    end
    return 0
  end

  def age(today)
    today - @day_bought
  end

  def sell_price(today)
    if @type == :pig
      age(today) * 15
    else
      age(today) * 3
    end 
  end

  def emoji
    case @type
      when :cow then '🐮'
      when :pig then '🐷'
      when :chicken then '🐔'
      else ''
    end
  end
end
