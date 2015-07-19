class Board
  attr_accessor :data

  def initialize
    @data = {}
    (1..9).each {|position| @data[position] = Square.new(' ')}
  end

  def system_clear
    system("cls")
    system("clear")
  end

  def draw
    system_clear

    puts "          KEY          "
    puts "       |       |                        |       |       "
    puts "   1   |   2   |   3                #{@data[1].value}   |   #{@data[2].value}   |   #{@data[3].value}   "
    puts "       |       |                        |       |       "
    puts "-------+-------+-------          -------+-------+-------"
    puts "       |       |                        |       |       "
    puts "   4   |   5   |   6                #{@data[4].value}   |   #{@data[5].value}   |   #{@data[6].value}   "
    puts "       |       |                        |       |       "
    puts "-------+-------+-------          -------+-------+-------"
    puts "       |       |                        |       |       "
    puts "   7   |   8   |   9                #{@data[7].value}   |   #{@data[8].value}   |   #{@data[9].value}   "
    puts "       |       |                        |       |       "
  end

  def empty_squares
    @data.select {|_,square| square.value == " "}.keys
  end

  def board_filled?
    empty_squares.size == 0
  end

  def winner_found?
    someone_won = false
    combination_symbols = []
    winning_combinations = [[1,2,3], [4,5,6], [7,8,9], [1,5,9], [7,5,3], [1,4,7], [2,5,8], [3,6,9]]
    winning_combinations.each do |combination|
      combination.each do |space|
        combination_symbols << @data[space].value
      end
      combination_symbols.uniq!
      someone_won = true if combination_symbols.count == 1 && !combination_symbols.include?(' ')
      combination_symbols = []
    end
    someone_won
  end
end

class Player
  attr_reader :name, :marker

  def initialize(name, mark)
    @name = name
    @marker = mark
  end
end

class Square
  attr_accessor :value

  def initialize(value)
    @value = value
  end

  def mark(marker)
    @value = marker
  end
end

class Game
  def initialize
    @board = Board.new
    puts "Please enter your name:"
    @human = Player.new(gets.chomp, "X")
    @computer = Player.new("Computer", "O")
    @current_player = who_goes_first
  end

  def who_goes_first
    ["human","computer"].sample
  end

  def play_again?
    @play_again = false
    begin
      puts "Do you wish to play again? (Y/N)"
      answer = gets.chomp.downcase
    end until answer == 'y' || answer == 'n'
    @play_again = true if answer == 'y'
    @play_again
  end

  def play
    @board.draw
    begin
      if @current_player == "human"
        puts "#{@human.name}'s turn."
        begin
          puts "Choose which empty space to place your X in:"
          @chosen_space = gets.to_i
        end until @board.empty_squares.include?(@chosen_space)
        @board.data[@chosen_space].mark("X")
        if @board.winner_found?
          @board.draw
          puts "YOU HAVE WON!"
          break
        end
        @current_player = "computer"
      else
        @chosen_space = @board.empty_squares.sample
        @board.data[@chosen_space].mark("O")
        if @board.winner_found?
          @board.draw
          puts "THE COMPUTER WINS!"
          break
        end
        @current_player = "human"
      end
      @board.draw
    end until @board.board_filled? || @board.winner_found?
    
    if play_again?
      Game.new.play
    end
  end
end

Game.new.play
