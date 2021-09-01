require './animal.rb'

# TODO

# fruit trees
# more plants

# different seasons

# sell pig but only after 10 or more days for money

# tornados that can carry off chickens and some plants
# hurricanes that can carry off all types of animals and plants

# plague that kills all of one type of animal
# old age killing animals

# invest in barn and coop
DAYS_IN_MONTH = 2
INTEREST_RATE = 6
LOAN_TERM = 12

@original_loan = 0
@loan = 0

@money = 0
@wheat = 10
@day = 0
@running = true
@animals = []

def print_status
  puts "======It is day number #{@day}======"
  puts "You have $#{@money.round(2)}"
  puts "You have #{@wheat} wheat"
  if @animals.size < 1
    puts 'You have no animals.'
  else
    @animals.each do |animal|
      puts "you have a #{animal.print(@day)}"
    end
  end
end

def buy_something
  puts 'What would you like to buy? [animal, wheat]'
  input = gets.chomp.downcase
  case input
  when 'animal', 'a'
    buy_animal
  when 'wheat', 'w'
    buy_wheat
  end
end

def buy_wheat
  puts 'How much wheat would you like to buy?'
  input = gets.chomp.to_i
  @wheat += input
  @money -= input*2
  puts "You bought #{input} wheat for $#{input*2}"
end

def generate_name
  firsts = ["Arnold", "Phylis", "Leopold", "Mortimer", "Dr SnuffSnuff", "Esmerelda", "Gesundheit", "Bessie"]
  
  lasts = ["McMickalMick", "O'Rorke", "Smith", "Cow", "Quackerstein", "Schumpeter", "Washington"]

  name = "#{firsts.sample} #{lasts.sample}"
  name
end

def buy_animal
  puts 'What would you like to buy? [cow (400), chicken (100), normal_pig (250), truffle_finding_pig (4000)]'
  input = gets.chomp.downcase
  animal = nil
  case input
  when 'cow', 'c'
    animal = Animal.new(type: :cow, cost: 400, name: generate_name, day_bought: @day)
  when 'chicken', 'ch'
    animal = Animal.new(type: :chicken, cost: 100, name: generate_name, day_bought: @day)
  when 'pig', 'p'
    animal = Animal.new(type: :pig, cost: 250, name: generate_name, day_bought: @day)
  when 'truffle_finding_pig', 'tfp'
    puts 'Are you sure you want to buy a truffle finding pig? They cost a lot.'
    input = gets.chomp.downcase
    animal = nil
    case input
    when 'yes'
      animal = Animal.new(type: :truffle_finding_pig, cost: 4000, name: generate_name, day_bought: @day)
    when 'no'
      puts 'Okay, you will not buy a truffle finding pig'
    end
  end
  puts "You bought a #{animal.type} named #{animal.name}"
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
    when 'buy', 'b'
      buy_something
    when 'status', 's'
      print_status
    when 'wait', 'w'
      do_end_of_day_things
    when 'exit', 'e'
      @running = false
    end

  end
end

def pay_loan
  r = (INTEREST_RATE / 12.0 / 100.0)
  
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


# for each animal, feed it from @wheat
# if there isn't enough wheat ... 
def feed_animals
  @animals.each do |a|
    if @wheat > 0
      a.feed
      @wheat -= 1
    end
  end
end

def do_animal_day_things
  @animals.each do |a|
    result = a.do_end_of_day_things
    if result == :died
      @animals.delete(a)
    end
  end
end


def harvest_wheat

end

def do_monthly_things
  return unless @day % DAYS_IN_MONTH == 0
  
  harvest_wheat
  pay_loan
end


def do_end_of_day_things
  @day += 1
  
  feed_animals
  do_animal_day_things
  
  calculate_money

  do_monthly_things

  money_check
end


def money_check
  if @money < 0
    puts "You went broke. Bandits took over your farm and forced you to work for them. Then you died of a sudden heart attack. Too bad. If you were still alive, you would have been very proud of your animals because they went on to rule the world."
    @running = false
  end
end

main