require 'rainbow/refinement'
require './animal.rb'
using Rainbow

# TODO
# sell pig but only after 10 or more days for money
# fruit trees
# more plants
# different seasons
# tornados that can carry off chickens and some plants
# hurricanes that can carry off all types of animals     and plants
# plague that kills all of one type of animal
# old age killing animals
# saved games
# multiple years

DAYS_IN_MONTH = 28
INTEREST_RATE = 6
LOAN_TERM = 12
COST_OF_WHEAT = 4
@original_loan = 0
@loan = 0

@money = 0
@wheat = 1
@day = 0
@running = true
@animals = []

def print_status
  puts "It is day number #{@day}"
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

def underline_first(word, count=1)
  word.slice(0,count).underline + word[count..-1]
end

def buy_something
  puts "What would you like to buy? [#{underline_first("animal")}, #{underline_first("wheat")}]"
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
  @money -= input*COST_OF_WHEAT
  puts "You bought #{input} wheat for $#{input*COST_OF_WHEAT}"
end

def sell_something
  if @animals.size < 1
    puts 'You have no animals.'
    return
  else
    puts "Here are your animals:"
    
    @animals.each_with_index do |animal, count|
      puts "##{count}) #{animal.print(@day)} and will sell for $#{animal.sell_price(@day)}"  
    end
  end
  puts 'Who would you like to sell (number)?'
  
  input = gets.chomp.downcase.to_i
  to_sell = @animals[input]
  
  sell_price = to_sell.sell_price(@day)

  puts "ok, selling #{to_sell.print(@day)} for $#{sell_price}"

  @money += sell_price

  @animals.delete(to_sell)

end

def generate_name
  firsts = ["Arnold", "Phylis", "Leopold", "Mortimer", "Dr SnuffSnuff", "Esmerelda", "Gesundheit", "Bessie"]
  
  lasts = ["McMickalMick", "O'Rorke", "Smith", "Cow", "Quackerstein", "Schumpeter", "Washington"]

  name = "#{firsts.sample} #{lasts.sample}"
  name
end

def buy_animal
  puts "What would you like to buy? [#{underline_first("cow")} (400), #{underline_first("chicken",2)} (100), #{underline_first("pig")} (250), #{underline_first("truffle_finding_pig")} (4000)]"
  input = gets.chomp.downcase
  animal = nil
  case input
  when 'cow', 'c'
    animal = Animal.new(type: :cow, cost: 400, name: generate_name, day_bought: @day)
  when 'chicken', 'ch'
    animal = Animal.new(type: :chicken, cost: 100, name: generate_name, day_bought: @day)
  when 'pig', 'p'
    animal = Animal.new(type: :pig, cost: 250, name: generate_name, day_bought: @day)
  when 'truffle_finding_pig', 't'
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
      puts 'Cow milked for $12'
      new_money += 12
    when :chicken
      puts 'Chicken eggs sell for 79 cents'
      new_money += 0.79
    when :truffle_finding_pig
      puts 'truffles sell for $114'
      new_money += 114
    end
  end
  puts "You gained #{new_money} but the taxes ruduced 12%, which is #{(new_money*0.12).round(2)},so you gained #{(new_money*0.88).round(2)}"

  @money += (new_money*0.88)
end

def new_loan
  puts <<~EOS
  Welcome to 

 #######                            #                                                           
 #         ##   #####  #    #      # #   #####  #    # ###### #    # ##### #    # #####  ###### 
 #        #  #  #    # ##  ##     #   #  #    # #    # #      ##   #   #   #    # #    # #      
 #####   #    # #    # # ## #    #     # #    # #    # #####  # #  #   #   #    # #    # #####  
 #       ###### #####  #    #    ####### #    # #    # #      #  # #   #   #    # #####  #      
 #       #    # #   #  #    #    #     # #    #  #  #  #      #   ##   #   #    # #   #  #      
 #       #    # #    # #    #    #     # #####    ##   ###### #    #   #    ####  #    # ###### 
                                                                                                                                                                       
  To get started you will have to take out a loan. The intrest rate is #{INTEREST_RATE}% over #{LOAN_TERM} months. How much would you like to take out?"
  EOS
  @loan = gets.chomp.to_f
  @money = @loan
  @original_loan = @loan
end


def main
  new_loan
  while @running
    puts "Welcome to day #{(1 + @day % DAYS_IN_MONTH).to_i} of month #{1 + (@day / DAYS_IN_MONTH).floor}.".yellow
    puts " Money $#{@money.round(2)}".green
    puts " Wheat #{@wheat}".yellow
    puts " Animals #{@animals.size}".blue

    puts "What would you like to do? [#{underline_first("buy")}, #{underline_first("sell")} #{underline_first("info")}, #{underline_first("wait")}, #{underline_first("exit")}]"

    input = gets.chomp.downcase

    case input
    when 'buy', 'b'
      buy_something
    when 'info', 'i'
      print_status
    when 'sell', 's'
      sell_something
    when 'wait', 'w'
      do_end_of_day_things
    when 'exit', 'e'
      @running = false
    else
      puts "Hmmm, not sure what you meant."
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
    eaten = a.feed(@wheat)
    @wheat -= eaten
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

  
  do_animal_day_things
  do_natural_disasters
  calculate_money
  do_monthly_things
  money_check
  feed_animals
end

def do_natural_disasters
 if 0 == rand(3)
   eaten_chicken = @animals.select{|a| a.type == :chicken}.first
   unless eaten_chicken.nil?
    puts "A fox ate #{eaten_chicken.name} 😞".red.bright
    @animals.delete(eaten_chicken)
   end
 end

 if 0 == rand(5)
  tornado_desired_amount = rand(20)
  carried_away_wheat = [tornado_desired_amount, @wheat].min
  puts "a tornado happened during the night and carryed away #{carried_away_wheat} wheat".red.bright
  @wheat -= carried_away_wheat
 end
end

def money_check
  if @money < 0
    puts "You went broke. Then you died of a sudden heart attack. Too bad. If you were still alive, you would have been very proud of your animals because they went on to rule the world."
    @running = false
  end
end

main