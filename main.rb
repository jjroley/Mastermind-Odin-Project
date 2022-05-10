

class Mastermind
  def initialize()
    @turn = 1
    @pattern = generate_pattern
  end
  def generate_pattern
    colors = ['red','blue','green','yellow','black','white']
    Array.new(4).map{ |_| colors.sample }
  end
  def begin
    puts 'write you guesses in this format: 4 names of colors divided by commas (e.g. red,green,blue,black)'
    puts 'possible colors are white, black, red, yellow, green, blue'
    while @turn <= 10
      puts "You have #{11 - @turn} guesses left"
      puts "make a guess"
      guess_arr = gets.chomp.split(/,\s*/)
      results = guess(guess_arr)
      puts "#{results.select{|r| r == 2 }.length} that are the correct color and correct position"
      if results.length == 4 && results.all? { |r| r == 2 }
        puts "The pattern was #{@pattern.join(', ')}"
        puts "You won in #{@turn} guesses!"
        exit
      end
      puts "#{results.select{|r| r == 1 }.length} that are correct color"
      @turn += 1
    end
    puts "The pattern was #{@pattern.join(', ')}"
    puts "You lost."
  end
  def guess(guess_arr)
    arr = []
    pattern = @pattern.clone
    guess_arr.each_with_index do |g, i|
      if g == pattern[i]
        arr.push(2)
        pattern[i] = nil
        guess_arr[i] = nil
      end
    end
    pattern.compact!
    guess_arr.compact!
    guess_arr.each do |g|
      index = pattern.index(g)
      if index != nil
        pattern[index] = nil
        pattern.compact!
        arr.push(1)
      end
    end
    arr
  end
end

game = Mastermind.new

game.begin
