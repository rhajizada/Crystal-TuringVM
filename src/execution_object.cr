require "./instruction.cr"
require "./end_message.cr"
require "./instruction_type.cr"
require "log"

module TuringVM
    # ExecutionObject is used for running the loaded program
    # Contains the attributes of the running program
    class ExecutionObject
        property ir : UInt16 = 0 # Instruction Register
        property ic : Int32 = 0 #  Instruction Counter
        property mc : Int32 = 0 # Movement Counter
        property cr : Bool = false # Compare register
        property instruction : Instruction = Instruction.new(0.to_u16)# Stores decoded instruction object that will be executed
        property alphabeth : Array(Char) = ['\u0000'] # Array that stores allowed characters
        property done : Bool = false # Program finished or not
        property end_message : ::EndMessage = ::EndMessage::FAIL # Same as exit code

        def initialize
        end

        def set_instruction(instruction : Instruction) : Nil
            # Sets the current instruction to given one
            @instruction = instruction
        end

        def increment_ir : Nil
            # Increments the Instruction Register
            Log.debug { "Incrementing instruction register"}
            @ir += 1
        end

        def set_ir(address : UInt16)
            # Sets instruction register to the given one
            Log.debug { "Setting instruction register to '#{address}'" }
            @ir = address
        end

        def set_ir(address : Nil)
        end

        def increment_ic : Nil
            # Increments the instruction counter
            Log.debug { "Incrementing instruction counter"}
            @ic += 1
        end

        def increment_mc : Nil
            # Increments the movements counter
            Log.debug { "Incrementing tape head movement counter" }
            @mc += 1
        end

        def add_to_alphabeth(letter : Char) : Nil
            # Adds given letter to the alphabeth
            if !@alphabeth.includes?(letter)
                Log.debug { "Adding letter #{letter} to alphabeth" }
                alphabeth.push(letter)
            end
        end

        def add_to_alphabeth(letter : Nil) : Nil
        end

        def remove_from_alphabeth(letter : Char) : Nil
            # Removes the given letter from the alphabeth
            if !@alphabeth.includes?(letter)
                @end_message = ::EndMessage::FAIL
                @end = true
                Log.error { "Cannot remove letter '#{letter}' from alphabeth"}
            else
                Log.debug { "Removing letter '#{letter}' from alphabeth" }
                @alphabeth.delete(letter)
            end
        end

        def remove_from_alphabeth(letter : Nil) : Nil
        end

        def set_cr(x : Bool) : Nil
            # Setting Compare register value
            Log.debug{ "Setting compare register to '#{x}'"}
            @cr = x
        end

        def set_cr(x : Nil) : Nil
        end

        def fix_cr : Nil
            # If the current instruction type is not CMP resets Compare Register
            if(@instruction.opt_type != InstructionType::CMP)
                self.set_cr(false)
            end
        end

        def halt : Nil
            # Finishes the program with HALT status
            @end_message = ::EndMessage::HALT
            @done = true
        end

        def fail : Nil
            # Finishes the program with FAIL status
            @end_message = ::EndMessage::FAIL
            @done = true
        end

    end
end

