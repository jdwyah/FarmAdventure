require './animal.rb'
#  ruby main.rb


@money = 10_000
@day = 1
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
  case input
  when 'cow'
    @money -= 400
    @animals << 'cow'
  when 'chicken'
    @money -= 100
    @animals << 'Chicken'
  when 'pig'
    @money -= 250
    @animals << 'Pig'
  end
end

def calculate_money
  new_money = 0
  for animal in @animals
    case animal
    when 'cow'
      puts "Cow milked for $10"
      new_money += 10
    end
  end
  puts "You gained #{new_money}"
  @money += new_money
end

def main
  while @running

    puts 'What would you like to do? [buy, status, wait, exit]'

    input = gets.chomp.downcase

    case input
    when 'buy'
      buy_something
    when 'status'
      print_status
    when 'exit'
      @running = false
    end

    calculate_money
     
    @day += 1 
  end
end
def wait
  @day += 1  
end

main
#a = Animal.new