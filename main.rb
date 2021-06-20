require './animal.rb'
#  ruby main.rb


@money = 10_000
@wheat = 0
@day = 0
@running = true

@animals = []

def print_status
  puts "You have $#{@money}"
  puts "It is day number #{@day}"
  if @animals.size < 1
    puts 'You have no animals.'
  else
    @animals.each do |animal|
      puts "you have a #{animal}"
    end
  end
end

def buy_something
  puts 'What would you like to buy? [cow, chicken, pig]'
  input = gets.chomp.downcase
  animal = nil
  case input
  when 'cow'
    animal = Animal.new(type: :cow, cost: 400, name: "Bessie", day_bought: @day)
  when 'chicken'
    animal = Animal.new(type: :chicken, cost: 100, name: "Ester", day_bought: @day)
  when 'pig'
    animal = Animal.new(type: :pig, cost: 250, name: "Porky", day_bought: @day)
  end
  @money -= animal.cost
  @animals << animal
end

def calculate_money
  new_money = 0
  for animal in @animals
    case animal.type
    when :cow
      puts "Cow milked for $10"
      new_money += 10
    when :chicken
      puts "Chicken eggs sell for 50 cents"
      new_money += 0.5
    end
  end
  puts "You gained #{new_money}"
  @money += new_money
end

def main
  month_length = 3.0
  while @running
    puts "Welcome to day #{(1 + @day % month_length).to_i} of month #{1 + (@day / month_length).floor}."
    puts 'What would you like to do? [buy, status, wait, exit]'

    input = gets.chomp.downcase

    case input
    when 'buy'
      buy_something
    when 'status'
      print_status   
    when 'wait'
      wait  
    when 'exit'
      @running = false  
    end
    
  end
end

def wait
  @day += 1 

  calculate_money
end


main
#a = Animal.new