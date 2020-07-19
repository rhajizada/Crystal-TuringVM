require "./letter.cr"
require "log"
require "colorize"

module TuringVM
    # Class that contains the tape
    class Tape
        property index : Int32
        property tape : Array(Letter)

        def initialize(tape_string : String)
            # Constructor parses tape line (string) into Tape object
            Log.debug { "Intializing tape object" }
            @tape = Array(Letter).new
            tape_string.each_char do |tape_character|
                tape.push(Letter.character_letter(tape_character))
            end
            @index = 0
        end

        def left : Nil
            # Moves tape head left
            Log.debug { "Moving tape head to the left" }
            if @index - 1 < 0
                @tape.unshift(Letter.empty_letter)
            else
                @index -= 1
            end
        end

        def right : Nil
            # Moves tape head right
            Log.debug { "Moving tape head to the right" }
            @index += 1
            if @index > @tape.size - 1
                @tape.push(Letter.empty_letter)
            end
        end

        def compare(letter : Letter) : Bool
            # Compares letter with tape at the current head
            Log.debug { "Comparing #{letter.character} to #{@tape[@index].character}"}
            if @index > @tape.size - 1
                self.right
            end
            return letter == @tape[@index]
        end

        def compare(letter : Nil) : Nil
        end

        def to_s: String
            # Casts tape to string
            return_string : String = ""
            @tape.each do |letter|
                if letter.is_empty
                    return_string += ' '
                else
                    return_string += letter.character
                end
            end
            return return_string
        end

        def draw(letter : Letter) : Nil
            # Puts given letter into tape at current head position
            Log.debug { "Drawing letter #{letter.character} to the tape at index #{@index}"}
            @tape[@index] = letter
        end

        def draw(letter : Nil) : Nil
        end

        def print : Nil
            # Prints tape as well as the current tape positon
            final_string = self.to_s + '\n'
            37.times do
                final_string += " "
            end
            final_string += "^"
            Log.info { final_string }
        end

        def to_s_with_head : String
            # Returns tape and given tape head position as a string
            final_string = self.to_s + '\n'
            @index.times do
                final_string += " "
            end
            final_string += "^"
            return final_string
        end
    end
end