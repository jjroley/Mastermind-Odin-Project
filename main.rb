

class MastermindLogic
  attr_writer :max_turn
  attr_reader :game_over, :turn, :max_turn
  def initialize(pattern)
    @pattern = pattern
    @turn = 1
    @max_turn = 10
    @game_over = false
  end
  def guess(guess_arr)
    return nil unless @turn <= @max_turn
    exact = 0
    color = 0
    new_pattern = @pattern.clone
    guess_arr.each_with_index do |g, i|
      if g == new_pattern[i]
        exact += 1
        new_pattern[i] = nil
        guess_arr[i] = nil
      end
    end
    new_pattern.compact!
    guess_arr.compact!
    guess_arr.each do |g|
      index = new_pattern.index(g)
      if index != nil
        new_pattern[index] = nil
        new_pattern.compact!
        color += 1
      end
    end
    @turn += 1
    if @turn >= @max_turn
      @game_over = true
    end
    [exact, color]
  end
  def turns_left
    @max_turn - @turn + 1
  end
  def self.generate_pattern
    colors = ['red','blue','green','yellow','black','white']
    Array.new(4).map{ |_| colors.sample }
  end
end

class ComputerSolver
  def initialize(game) 
    @game = game
  end
  def begin
    while true
      pattern = MastermindLogic.generate_pattern
      puts "The computer guesses #{pattern.join(', ')}"
      guess = @game.guess(pattern)
      if guess[0] == 4
        puts "The computer cracked the code in #{@game.turn} tries!"
        break;
      end
      if @game.game_over
        puts "The computer failed to solve the code"
        break;
      end
    end
  end
end

class Mastermind
  def begin
    while true
      puts 'Would you like to be the cracker or the code-setter?'
      puts "Enter 1 for cracker or 2 for code-setter"
      response = gets.chomp
      if response == '1'
        start_player
      else
        start_computer
      end
      puts "Would you like to play again? Enter yes or no"
      break unless gets.chomp.downcase == 'yes'
    end
    puts "Thanks for playing Mastermind"
  end
  def start_computer
    puts "Create the code"
    code = gets.chomp.split(/,\s*/)
    game = MastermindLogic.new(MastermindLogic.generate_pattern)
    ComputerSolver.new(game).begin
  end
  def start_player
    pattern = MastermindLogic.generate_pattern
    game = MastermindLogic.new(pattern)
    while !game.game_over
      puts "You have #{game.turns_left} guesses left"
      puts "make a guess"
      guess_arr = gets.chomp.split(/,\s*/)
      results = game.guess(guess_arr)
      puts "#{results[0]} that are the correct color and correct position"
      if results[0] == 4
        puts "The pattern was #{pattern.join(', ')}"
        puts "You won in #{turn} guesses!"
        exit
      end
      puts "#{results[1]} that are correct color"
    end
    puts "The pattern was #{pattern.join(', ')}"
    puts "You lost."
  end
end

Mastermind.new.begin
