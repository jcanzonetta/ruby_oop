module RenderBoard
  GRID_VALUES = {
    'TL' => [0, 0],
    'T' => [0, 1],
    'TR' => [0, 2],
    'L' => [1, 0],
    'C' => [1, 1],
    'R' => [1, 2],
    'BL' => [2, 0],
    'B' => [2, 1],
    'BR' => [2, 2]
  }.freeze

  X_O_CONVERSION = {
    'X' => 1, 'O' => 2
  }.freeze

  def render
    @board.each_with_index do |row, i|
      row.each_with_index do |square, j|
        if square == 1
          print ' X '
        elsif square == 2
          print ' O '
        else
          print '   '
        end

        if j == 2
          puts nil
        else
          print '|'
          end
      end

      # Create a horizontal line
      RenderBoard.horizontal_line unless i == 2
    end

    puts nil
  end

  def hint
    puts ' TL | T | TR '
    RenderBoard.horizontal_line
    puts '  L | C | R '
    RenderBoard.horizontal_line
    puts " BL | B | BR \n\n"
  end

  def self.horizontal_line
    12.times do
      print '-'
    end

    puts nil
  end
end

class Round
  include RenderBoard

  def initialize(player1, player2)
    @board = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
    @player1 = player1
    @player2 = player2
    @next_player = @player1
    @game_over = false

    puts "\n#{@player1.name} goes first.\n\n"
    puts "Only enter the pieces as follows:\n\n"
    hint

    until @game_over == true
      place_piece(get_play, @next_player.x_o)
      @next_player = @next_player == @player1 ? @player2 : @player1
      test_for_winner
      test_for_tie
    end

    print "\nPlay again? (y/n)"

    loop do
      new_game = gets.chomp.downcase

      if new_game == 'y' || new_game == 'yes'
        round = Round.new(@player1, @player2)
        break
      elsif new_game == 'n' || new_game == 'no'
        break
      end

      print 'Invalid input, please enter (y/n or yes/no).'
    end
  end

  def test_for_winner
    # check rows and columsn for a winner
    (0..2).each do |i|
      if (@board[i][0] == @board[i][1] && @board[i][1] == @board[i][2]) && @board[i][0] != 0 # Check rows for a winner.
        return declare_winner(@board[i][0])
      elsif (@board[0][i] == @board[1][i] && @board[1][i] == @board[2][i]) && @board[0][i] != 0 # Check columns for a winner. I could combine this into the if statement above, but I'm separating them for readibility.
        return declare_winner(@board[0][i])
      end
    end

    if ((@board[0][0] == @board[1][1] && @board[1][1] == @board[2][2]) || (@board[0][2] == @board[1][1] && @board[1][1] == @board[2][0])) && @board[1][1] != 0
      declare_winner(@board[1][1])
    end
  end

  def declare_winner(x_or_o_int)
    winner = X_O_CONVERSION[@player1.x_o] == x_or_o_int ? @player1 : @player2
    puts "#{winner.name} wins!"
    @game_over = true
  end

  def test_for_tie
    return nil if @game_over == true

    @board.each do |row|
      row.each do |square|
        return @game_over = false if square == 0
      end
    end
    puts "It's a tie!"
    @game_over = true
  end

  def get_play
    print "#{@next_player.name}'s turn: "

    play = gets.chomp.upcase
    puts nil

    loop do
      break if RenderBoard::GRID_VALUES[play]

      puts "\nIncorrect input. Hint:\n\n"
      hint
      play = gets.chomp.upcase
    end

    RenderBoard::GRID_VALUES[play]
  end

  def place_piece(coordinate, piece)
    loop do
      i = coordinate[0]
      j = coordinate[1]

      if @board[i][j] == 0
        @board[i][j] = X_O_CONVERSION[piece]
        break
      end

      puts 'That spot is taken.'
      coordinate = get_play
    end

    render
  end
end

# board object with rows and columns?
class Game
  attr_reader :player1, :player2

  def initialize
    puts "\nTic-Tac-Toe! - A Ruby project by Justin Canzoentta \n\n"
    @player1 = Player1.new
    @player2 = Player2.new(@player1.x_o)

    announce

    @round = Round.new(@player1, @player2)
  end

  def announce
    puts "\n#{player1.name} will be playing as #{player1.x_o}'s."
    puts "#{player2.name} will be playing as #{player2.x_o}'s."
  end
end

# player superclass
class Player1
  attr_reader :name, :x_o

  def initialize
    print 'Player 1, enter name: '
    @name = gets.chomp # Will change to gets.chomp
    print 'Will you be X or O?  '
    @x_o = x_o_check # will change to gets.chomp
  end

  def x_o_check
    loop do
      input = gets.chomp.upcase

      return input if input == 'X' || input == 'O'

      puts 'Please enter X or O.'
    end
  end
end

class Player2 < Player1
  def initialize(other_x_o)
    print 'Player 2, enter name: '
    @name = gets.chomp # Will change to gets.chomp
    @x_o = other_x_o == 'X' ? 'O' : 'X'
  end
end

game = Game.new
