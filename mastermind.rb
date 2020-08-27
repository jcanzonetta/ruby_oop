
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

    def get_number
        
        num = gets.chomp.to_i
        
        until num > 1 do
            print "\nPlease enter a whole number greater than 1: "
            num = gets.chomp.to_i
        end

        return num
    end

end

# Defines the number of pegs and colors
class GameBoard
    attr_reader :holes, :colors, :turns
    
    def initialize(holes, colors, turns, code)
        @holes = holes
        @colors = colors
        @turns = turns
        @field = create_field()
        @code = code
    end

    def create_field
        return Array.new(@turns, Array.new(@holes, 0))
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
class Player
    attr_reader :codebreaker
    
    def initialize(codebreaker)
        @codebreaker = codebreaker
        @name = self.get_name

        
    end

    def get_name
        print 'Please enter your name: '
        puts "It'll be Justin for testing."
        return "Justin"#gets.chomp # Will change to gets.chomp
    end

end

# Defines the 2nd Player (code maker)
class Computer
    
    def initialize(codebreaker)
        print 'Player 2 (Mastermind?), enter name: '
        puts @name = "Computer for now"
        
        @codebreaker = codebreaker == true ? false : true
    end



end

class Game
    include INPUT
    
    attr_reader :player, :computer
    
    def initialize
        puts "\nMastermind! - A Ruby project by Justin Canzoentta \n\n"
        @player = Player.new(determine_codebreaker)
        @computer = Computer.new(@player.codebreaker)
        holes = self.get_holes
        colors = self.get_colors
        @board = GameBoard.new(holes, colors, self.get_turns, self.get_code(holes, colors))
        
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
        end

        # ask to initialize a new game

    end

    def get_code(holes, colors)
        if @player.codebreaker == true
            print "Enter the code you will use for the answer"
            puts "[1, 2, 3, 4] will be used for testing"
            return [1, 2, 3, 4]
        else
            return self.computer_generate_code(holes, colors)
        end
    end

    def computer_generate_code(holes, colors)
        prng = Random.new()
        code = []
        holes.times do
            code.push(prng.rand(colors))
        end
        p code
        return code
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

    def get_holes
        print "How many holes do you want? "
        return self.get_number
    end

    def get_colors
        print "How many \"colors\"? "
        return self.get_number
    end

    def get_turns
        print "How many turns? "
        return self.get_number
    end

end

game = Game.new