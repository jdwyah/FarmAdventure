require './animal.rb'

# TODO

# grain, grain_seeds, feed
# fruit trees
# more plants

# animals need to eat
# how much feed each type of animals need

# sell pig but only after 10 days for money

# tornados that can carry off chickens and some plants
# hurricanes that can carry off all types of animals and plants

# plague that kills all of one type of animal
# old age killing animals

# invest in barn and coop
DAYS_IN_MONTH = 2
INTEREST_RATE = 0.06
LOAN_TERM = 12

@original_loan = 0
@loan = 0

@money = 0
@feed = 100
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
      puts "you have a #{animal.print(@day)}"
    end
  end
end

def buy_something
  puts 'What would you like to buy? [animal, plant]'
  input = gets.chomp.downcase
  case input
  when 'animal'
    buy_animal
  end
end

def buy_animal
  puts 'What would you like to buy? [cow (needs barn), chicken (needs coop), normal pig (needs barn), truffle_finding_pig (needs barn)]'
  input = gets.chomp.downcase
  animal = nil
  case input
  when 'cow'
    animal = Animal.new(type: :cow, cost: 400, name: 'Bessie', day_bought: @day)
  when 'chicken'
    animal = Animal.new(type: :chicken, cost: 100, name: 'Ester', day_bought: @day)
  when 'normal_pig'
    animal = Animal.new(type: :pig, cost: 250, name: 'Porky', day_bought: @day)
  when 'truffle_finding_pig'
    puts 'Are you sure you want to buy a truffle finding pig? They cost a lot.'
    input = gets.chomp.downcase
    animal = nil
    case input
    when 'yes'
      animal = Animal.new(type: :truffle_finding_pig, cost: 5000, name: 'Moneymaker', day_bought: @day)
    when 'no'
      puts 'Okay, you will not buy a truffle finding pig'
    end
  end
  @money -= animal.cost
  @animals << animal
end

def calculate_money
  new_money = 0
  @animals.each do |animal|
    case animal.type
    when :cow
      puts 'Cow milked for $10'
      new_money += 10
    when :chicken
      puts 'Chicken eggs sell for 50 cents'
      new_money += 0.5
    when :truffle_finding_pig
      puts 'truffles sell for $100'
      new_money += 100
    end
  end
  puts "You gained #{new_money} but the taxes ruduced 12%, which is #{(new_money*0.12).round(2)},so you gained #{(new_money*0.88).round(2)}"

  @money += (new_money*0.88)
end

def new_loan
  puts "Welcome to FarmAdventure. To get started you will have to take out a loan. The intrest rate is #{INTEREST_RATE}% over #{LOAN_TERM} months. How much would you like to take out?"
  @loan = gets.chomp.to_f
  @money = @loan
  @original_loan = @loan
end


def main
  new_loan
  while @running
    puts "Welcome to day #{(1 + @day % DAYS_IN_MONTH).to_i} of month #{1 + (@day / DAYS_IN_MONTH).floor}."
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

def pay_loan
  r = (INTEREST_RATE / 12.0)
  
  top =  (1.0+r)**LOAN_TERM-1
  bottom = r*((1.0+r)**LOAN_TERM)
  # puts "n #{n}"
  # puts "r #{r}"
  # puts "top #{top}"
  # puts "bottom #{bottom}"
  payment =  @original_loan / (top/bottom)
 
  @money -= payment
  @loan -= payment
  puts "Your loan payment of $#{payment.round(2)} has been applied."
end

def wait
  @day += 1
  calculate_money
  if @day % DAYS_IN_MONTH == 0
    pay_loan
  end

end

main
# a = Animal.new
