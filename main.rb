require 'rainbow/refinement'
require './animal.rb'
require 'rainbow/refinement'
require 'replit'
using Rainbow
@db = Replit::Database::Client.new
visitors = @db.get('visitors')
visitors += 1
@db.set('visitors', visitors)

# TODO
# 1 Loan day warning
# Loans : Lots of $ at high rate. Small amount at low rate.
#0 redo the fox probabilities 
#2 Buy wheat seed for $1 and 5 days later get a wheat.
# 3 different seasons
# 4 old age killing animals
# 5 fruit trees: question: can animals eat fruit? or they just make $$?
# 6 more plants
# 7 hurricanes that can carry off animals and plants
# 8 plague that kills all of one type of animal
# 9 multiple years/End at day XX and show high score if you want (don't really need)
DAYS_IN_MONTH = 28
GAME_LENGTH_IN_DAYS = DAYS_IN_MONTH * 12
INTEREST_RATE = 6
LOAN_TERM = 12
COST_OF_WHEAT = 3
SILO_COST = 150
MAYO_MACHINE_COST = 175
CHICKEN_COOP_COST = 380

@original_loan = 0
@loan = 0

@money = 0
@wheat = 10
@day = 0
@running = true
@animals = []
@has_a_silo = false
@fence_level = 0

def print_status
  puts "It is day number #{@day}"
  puts "You have $#{@money.round(2)}"
  puts "You have #{@wheat} wheat #{puts 'stored in a silo' if @has_a_silo}"

  if @animals.size < 1
    puts 'You have no animals.'
  else
    @animals.each do |animal|
      puts "you have a #{animal.print(@day)}"
    end
  end
end

def underline_first(word, count = 1)
  word.slice(0, count).underline + word[count..-1]
end

def buy_something
  puts "What would you like to buy? [#{underline_first('animal')}, #{underline_first('wheat')},
#{underline_first('silo')}, #{underline_first('fences')}]"
  input = gets.chomp.downcase
  case input
  when 'animal', 'a'
    buy_animal
  when 'wheat', 'w'
    buy_wheat
  when 'silo', 's'
    buy_silo
  when 'fences', 'f'
    buy_fences
  end
end

def buy_fences
  puts "What type of fence would you like to buy? [#{underline_first('basic fence')} $50, #{underline_first('super fence')} $100,]"
  input = gets.chomp.downcase
  case input
  when 'basic fence', 'b'
    if @money >= 50
      @fence_level = 1
      @money -= 50
      puts 'Marnie dropped by and built your basic fence!'
    else
      puts "Marnie dropped by and built your basic fence but then you didn't have enough money so she tore it down!"
    end
  when 'super fence', 's'
    if @money >= 100
      @fence_level = 2
      @money -= 100
      puts 'Marnie dropped by and built your super fence!'
    else
      puts "Marnie dropped by and built your super fence but then you didn't have enough money so she tore it down!"
    end
  end
end

def buy_wheat
  puts "How much wheat would you like to buy? (It's #{COST_OF_WHEAT} each)"
  input = gets.chomp.to_i
  @wheat += input
  @money -= input * COST_OF_WHEAT
  puts "You bought #{input} wheat for $#{input * COST_OF_WHEAT}"
end

def buy_silo
  puts "Buy a silo for $#{SILO_COST}? [yes, no]"
  input = gets.chomp.downcase
  animal = nil
  case input
  when 'yes'
    if @money > SILO_COST
      @money -= SILO_COST
      @has_a_silo = true

      puts '!!!!!Marnie stopped by and built you your silo!!!!!'
    else
      puts 'Not eenough money for a silo!!'
    end
  when 'no'
    puts 'Okay, you will not buy a silo.'
  end
end

def sell_something
  if @animals.size < 1
    puts 'You have no animals.'
    return
  else
    puts 'Here are your animals:'

    @animals.each_with_index do |animal, count|
      puts "##{count}) #{animal.print(@day)} and will sell for $#{animal.sell_price(@day)}"
    end
  end
  puts 'Who would you like to sell (number)?'

  input = gets.chomp.downcase.to_i
  to_sell = @animals[input]
  if to_sell.nil?
    puts "Couldn't find that animal"
    return
  end
  sell_price = to_sell.sell_price(@day)

  puts "ok, selling #{to_sell.print(@day)} for $#{sell_price}"

  @money += sell_price

  @animals.delete(to_sell)
end

def generate_name
  firsts = ['Arnold', 'Phylis', 'Leopold', 'Mortimer', 'Dr SnuffSnuff', 'Esmerelda', 'Gesundheit', 'Bessie', 'Bobbie', 'Fred', 'Floppy', 'Flipper']

  lasts = ['McMickalMick', "O'Rorke", 'Smith', 'Cow', 'Quackerstein', 'Schumpeter', 'Washington', 'McDonald',
           'Jones']

  name = "#{firsts.sample} #{lasts.sample}"
  name
end

def buy_animal
  puts "What would you like to buy? [#{underline_first('cow')} (450), #{underline_first('chicken', 2)} (40), #{underline_first('pig')} (275), #{underline_first('truffle_finding_pig')} (4000)]"
  input = gets.chomp.downcase
  animal = nil
  case input
  when 'cow', 'c'
    animal = Animal.new(type: :cow, cost: 450, name: generate_name, day_bought: @day)
  when 'chicken', 'ch'
    animal = Animal.new(type: :chicken, cost: 40, name: generate_name, day_bought: @day)
  when 'pig', 'p'
    animal = Animal.new(type: :pig, cost: 275, name: generate_name, day_bought: @day)
  when 'truffle_finding_pig', 't'
    puts "Are you sure you want to buy a truffle finding pig? They cost a lot. #{underline_first('yes')} #{underline_first('no')}"
    input = gets.chomp.downcase
    animal = nil
    case input
    when /yes|y/
      animal = Animal.new(type: :truffle_finding_pig, cost: 4000, name: generate_name, day_bought: @day)
    when /no|n/
      puts 'Okay, you will not buy a truffle finding pig'
    end
  else
    puts "You buy a #{input} for ONE MILLION DOLLARS.  No, I'm kidding. You are unable to buy a '#{input}'. Frankly, I'm not even sure I know what that is."
  end
  return if animal.nil?

  puts "You bought a #{animal.type} named #{animal.name} #{animal.emoji}"
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
      puts 'Chicken eggs sell for 5.79 cents'
      new_money += 5.79
    when :truffle_finding_pig
      puts 'truffles sell for $114'
      new_money += 114
    end
  end
  puts "You gained #{new_money} but the taxes ruduced 12%, which is #{(new_money * 0.12).round(2)},so you gained #{(new_money * 0.88).round(2)}"

  @money += (new_money * 0.88)
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
                                                                                                                                                                          
     To get started you will have to take out a loan. The intrest rate is #{INTEREST_RATE}% over #{LOAN_TERM} months. You can take up to $500, how much would you like to take out?"
  EOS
  puts "You are farmer ##{@db.get('visitors')}"
  @loan = gets.chomp.to_f
  if @loan > 500
    puts "That's more than $500!".red
    new_loan
  else
    @money = @loan
    @original_loan = @loan
    process_cheats
  end
end

def main
  new_loan

  while @running
    puts "Welcome to day #{(1 + @day % DAYS_IN_MONTH).to_i} of month #{1 + (@day / DAYS_IN_MONTH).floor}.".yellow

    puts " Money $#{@money.round(2)}".green
    puts " Wheat #{@wheat} #{'stored in a silo' if @has_a_silo}".yellow
    puts " Animals #{@animals.size}".blue

    puts "What would you like to do? [#{underline_first('buy')}, #{underline_first('sell')} #{underline_first('info')}, #{underline_first('wait')}, #{underline_first('exit')}]"

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
      puts 'Hmmm, not sure what you meant.'
    end

  end
end

def process_cheats
  puts "Loan is #{@loan}"
  if @loan == 1

    @animals << Animal.new(type: :chicken, cost: 100, name: generate_name, day_bought: @day)

    @animals << Animal.new(type: :cow, cost: 400, name: generate_name, day_bought: @day)

    @animals << Animal.new(type: :pig, cost: 250, name: generate_name, day_bought: @day)

    @wheat += 50
  end
  if @loan == 2
    @db.set('visitors', 0)
    @db.set('highscores', [])
    puts 'Highscores cleared'
    @running = false
  end
end

def pay_loan
  r = (INTEREST_RATE / 12.0 / 100.0)

  top =  (1.0 + r)**LOAN_TERM - 1
  bottom = r * ((1.0 + r)**LOAN_TERM)
  # puts "n #{n}"
  # puts "r #{r}"
  # puts "top #{top}"
  # puts "bottom #{bottom}"
  payment = @original_loan / (top / bottom)

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
    @animals.delete(a) if result == :died
  end
end

def harvest_wheat; end

def do_monthly_things
  return unless @day % DAYS_IN_MONTH == 0

  harvest_wheat
  pay_loan
end

def check_end_of_game
  if @day == GAME_LENGTH_IN_DAYS
    puts "Game over! Your final score was #{@money}"
    @running = false
    highscores = @db.get('highscores') || []

    puts 'Please enter your name'

    input = gets.chomp
    new_entry = { score: @money, player: input }
    # [
    #   {score: 123, player: 'best'},
    #   {score: 101, player: 'middle'},
    #   {score: 1, player: 'worst'},
    # ]

    highscores << new_entry
    highscores = highscores.sort_by { |entry| entry[:score] }.reverse.first(10)
    highscores.each_with_index do |entry, i|
      puts " #{i + 1} Player: #{entry[:player]}, Score: #{entry[:score]}"
    end
    @db.set 'highscores', highscores
  end
end

def do_end_of_day_things
  @day += 1

  do_animal_day_things
  do_natural_disasters
  calculate_money
  do_monthly_things
  money_check
  feed_animals
  check_end_of_game
end

#
# fox < 10
# FOX!!!!
# if
# super_fence < 4 chicken eaten
# super > 4 and  < 10 fox came
#

def do_natural_disasters
  random_number = rand(100)
  if random_number <= 20
    puts '🦊Fox came!!!'
    at_risk_chicken = @animals.select { |a| a.type == :chicken }.first

    if at_risk_chicken
      # do chi
      puts "🦊👀Oh no, the fox is eying #{at_risk_chicken.name}."
      
      eaten = true if @fence_level == 0
      eaten = true if (@fence_level == 1) && (random_number <= 25)
      eaten = true if (@fence_level == 2) && (random_number <= 10)

      if eaten
        puts '🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊'
        puts "A fox ate #{at_risk_chicken.name} 😞".red.bright
        puts '🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊'
        @animals.delete(at_risk_chicken)
      else
        puts "🚧🚧 Your fence saved #{at_risk_chicken.name} 🚧🚧 "
      end
    else
      puts "Fox is sad😭🦊. You don't have any chickens."
    end
  end

  # a tornado hits with this probability
  if 0 == rand(7)

    # this is how much the tornado wants to take
    tornado_desired_amount = rand(1..20)

    # limit tornado to how much wheat we have
    tornado_desired_amount = [tornado_desired_amount, @wheat].min

    if @has_a_silo
      puts '🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️'
      puts "A tornado happened during the night and would've carried away #{tornado_desired_amount} wheat".red.bright
      puts '🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️'

      if tornado_desired_amount > 10
        carried_away = tornado_desired_amount - 10
        puts "But it only carried away #{carried_away} because of your silo.".green.bright
        @wheat -= carried_away
      else
        puts 'But your silo saved it all.'.green.bright
      end
    else
      puts '🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️'
      puts "A tornado happened during the night carried away #{tornado_desired_amount} wheat".red.bright
      puts '🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️🌪️'
      @wheat -= tornado_desired_amount
    end
  end
end

def money_check
  if @money < 0
    puts 'You went broke. Then you died of a sudden heart attack. Too bad. If you were still alive, you would have been very proud of your animals because they went on to rule the world.'
    @running = false
  end
end

main
