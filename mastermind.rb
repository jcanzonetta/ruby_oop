
module INPUT
    def enter_array
        array = []
        
        for i in 1..@board.holes do 
            print "\nEnter slot #{i}: "
            user_guess = gets.chomp
            array.push(user_guess.to_i)
        end
        print "\n #{array}"
        return array
    end
end



# Defines the qualities of an individual peg.
class Peg
    def initialize

    end

end


# Defines the number of pegs and colors
class GameBoard
    attr_reader :holes, :colors, :turns
    
    def initialize(holes, colors, turns)
        @holes = holes
        @colors = colors
        @turns = turns
        @field = create_field()
        @code = self.get_code
    end

    def create_field
        return Array.new(@turns, Array.new(@holes, 0))
    end

    # ask the user for the code they will answer
    def get_code
        print "Enter the code you will use for the answer"
        puts "[1, 2, 3, 4] will be used for testing"
        return [1, 2, 3, 4]
    end

    def play_round(current_guess)
        if current_guess == @code
            puts "You won!"
            return true
        else
            @turns -= 1
            print " is not quite it. There are #{@turns} turns remaining."
            return false
        end
    end

    def show_answer(game_over)
        game_over == true ? @code : "Error"
    end

    def give_code_hint(current_guess)
        # white = correct color, incorrect position = 2
        # green = correct color and position = 1
        # blanks for everything else = 0
        hint = []
        reduced_code = @code.dup

        current_guess.each_with_index do |number, index|
            #check if number exists
            if reduced_code.include?(number)
                #check if number is in the correct position ? 
                if index == @code[index]
                    hint.push(2)
                else
                    hint.push(1)
                end
                reduced_code.slice!(reduced_code.index(number))
            else
                hint.push(0)
            end
        end
        print "\nYour code's results: "
        return hint.sort
    end

end

# Defines the 1st Player (code breaker)
class Player1
    def initialize(codebreaker)
        @codebreaker = codebreaker
        @name = self.get_name

        
    end

    def get_name
        print 'Player 1 (Codebreaker), enter name: '
        return "Justin"#gets.chomp # Will change to gets.chomp
    end

end

# Defines the 2nd Player (code maker)
class Player2 < Player1
    
    def initialize
        print 'Player 2 (Mastermind?), enter name: '
        puts @name = "Computer for now"
    end



end

class Game
    include INPUT
    
    attr_reader :player1, :player2
    
    def initialize
        puts "\nMastermind! - A Ruby project by Justin Canzoentta \n\n"
        @player1 = Player1.new(determine_codebreaker)
        @player2 = Player2.new
        @board = GameBoard.new(self.holes, self.colors, self.turns)
        @game_over = false

        #main game loop
        until @game_over == true do
            # query and place pieces
            current_guess = self.guess
            # check if any pieces are correct -> end game if winner, else give hint and decrement turns
            if @board.play_round(current_guess) == true
                @game_over = true
            elsif @board.turns > 0
                @game_over = false
                print @board.give_code_hint(current_guess)
            else
                @game_over = true
                puts "\n\nGame over, you ran out of turns. Better luck next time."
                print "\n The code was #{@board.show_answer(@game_over)} \n\n"
            end

            # render code row and results matrix

            # check if there are any remaining turns -> show code if over
        end

        # ask to initialize a new game

    end

    def determine_codebreaker
        print "Would you like to play as the codebreaker? (y/n)"
        codebreaker = gets.chomp.downcase
        until codebreaker == "yes" || codebreaker == "no" || codebreaker == "y" || codebreaker == "n" do
            print "\n Incorrect input. (enter yes/no or y/n)"
            codebreaker = gets.chomp.downcase
        end

        puts nil

        if codebreaker == "yes" || codebreaker == "y"
            puts "You are the codebreaker, try to crack the code!\n\n"
            return true
        else
            puts "You will be the mastermind. The computer is going to try to break your code.\n\n"
            return false
        end
    end

    # ask the user what their guess is
    def guess
        puts "\nWhat'll it be? Enter from left to right."
        return self.enter_array
    end

    def holes
        print "How many holes do you want? "
        puts "4 will be used for testing"
        return 4
    end

    def colors
        print "How many \"colors\"? "
        puts "6 will be used for teting"
        return 6
    end

    def turns
        print "How many turns? "
        puts "12 will be used for testing"
        return 5
    end

end

game = Game.new