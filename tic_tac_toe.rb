module RenderBoard
    GRID_VALUES = {
        "TL" => [0, 0],
        "T" => [0, 1],
        "TR" => [0, 2],
        "L" => [1, 0],
        "C" => [1, 1],
        "R" => [1, 2],
        "BL" => [2, 0],
        "B" => [2, 1],
        "BR" => [2, 2]
    }

    X_O_CONVERSION = {
        "X" => 1, "O" => 2
    }

    def render
        @board.each_with_index do |row, i|
            row.each_with_index do |square, j|
                if square == 1
                    print " X "
                elsif square == 2
                    print " O "
                else
                    print "   "
                end

                unless j == 2
                    print "|"
                else
                    puts nil
                end
            end

            # Create a horizontal line
            unless i == 2
                RenderBoard.horizontal_line
            end
        end

        puts nil
        p @board
    end

    def hint      
        puts " TL | T | TR "
        RenderBoard.horizontal_line
        puts "  L | C | R "
        RenderBoard.horizontal_line
        puts " BL | B | BR \n\n"
    end

    def self.horizontal_line
        12.times do
            print "-"
        end
        
        puts nil
    end


end


class Round
    include RenderBoard

    def initialize(board, player1, player2)
        @board = board
        @player1 = player1
        @player2 = player2
        @next_player = @player1
        @game_over = false
        
        puts "\n#{@player1.name} goes first.\n\n"
        puts "Only enter the pieces as follows:\n\n"
        self.hint

        until @game_over == true do
            self.place_piece(self.get_play, @next_player.x_o)
            @next_player == @player1 ? @next_player = @player2 : @next_player = @player1

        end

        
    end

    # will check for incorrect inputs in the future
    def get_play
        puts "#{@next_player.name}'s turn."
        
        play = gets.chomp.upcase
        
        loop do
                 
            if RenderBoard::GRID_VALUES[play]
                break
            end

            puts "\nIncorrect input. Hint:\n\n"
            self.hint
            play = gets.chomp.upcase
        end
        
        RenderBoard::GRID_VALUES[play]
    end
    

    def place_piece(coordinate, piece)
        i = coordinate[0]
        j = coordinate[1]

        @board[i][j] = X_O_CONVERSION[piece]
        self.render
    end

    # if there's a winner
        # return winner
    # else if there aren't remaining plays
        # return tie
    # else
        # ask for a coordinate
        # update @board with new play
        # next turn


end



# board object with rows and columns?
class Game
    attr_reader :player1, :player2
    
    include RenderBoard

    def initialize
        @board = [[0, 0, 0],[0, 0, 0],[0, 0, 0]]

        puts "\nTic-Tac-Toe! - A Ruby project by Justin Canzoentta \n\n"
        self.render
        @player1 = Player1.new
        @player2 = Player2.new(@player1.x_o)

        @round = Round.new(@board, @player1, @player2)
    end
end

# player superclass
class Player1
    attr_reader :name, :x_o

    def initialize
        print "What's your name?  "
        puts @name = "Justin" # Will change to gets.chomp
        print "Will you be X or O?  "
        puts @x_o = "X" # will change to gets.chomp
    end
end

class Player2 < Player1

    def initialize(other_x_o)
        print "Who will be player 2? "
        @name = "Karina" # Will change to gets.chomp
        other_x_o == "X" ? @x_o = "O" : @x_o = "X"
        puts "#{@name} will be playing as #{x_o}'s."
    end


end

game = Game.new