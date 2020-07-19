require "./instruction.cr"
require "./letter.cr"
require "./tape.cr"
require "./execution_object.cr"
require "./end_message.cr"
require "log"

module TuringVM
    # Fetches the instruction from RAM that is located at the given address
    def fetch(ir : Int, ram = Array(Uint16)) : UInt16
        if ir > ram.size || ir < 0
            Log.error { "Failed at fetch stage invalid number in Instruction Register" }
            exit(1)
        end
        Log.debug { "Fetching instruction at register #{ir}"}
        return ram[ir] 
    end
    
    def decode(instruction_code : UInt16) : ::Instruction
        # Decodes the instruction code into actual isntruction
        Log.debug { "Decoding instruction #{instruction_code}"}
        decoded_instruction = ::Instruction.new(instruction_code)
        Log.debug { "Decoded instruction: #{decoded_instruction.to_s}"}
        return decoded_instruction
    end
    
    def execute(execution_object : ::ExecutionObject, tape : ::Tape)
        # Executes the intruction
        execution_object.increment_ic
        case execution_object.instruction.opt_type
        when ::InstructionType::ALPHA
          if execution_object.instruction.extra
            execution_object.add_to_alphabeth(execution_object.instruction.letter)
          else
            execution_object.remove_from_alphabeth(execution_object.instruction.letter)
          end
          execution_object.increment_ir
        when ::InstructionType::LEFT
            tape.left()
            execution_object.increment_ir
            execution_object.increment_mc
        when ::InstructionType::RIGHT
            tape.right()
            execution_object.increment_ir
            execution_object.increment_mc
        when ::InstructionType::HALT
            execution_object.halt
        when ::InstructionType::FAIL
            execution_object.fail
        when ::InstructionType::BRA
            execution_object.set_ir(execution_object.instruction.address)
        when ::InstructionType::BRAE
            if execution_object.cr
                execution_object.set_ir(execution_object.instruction.address)
            else
                execution_object.increment_ir
            end
        when ::InstructionType::BRANE
            if !execution_object.cr
                execution_object.set_ir(execution_object.instruction.address)
            else
                execution_object.increment_ir
            end
        when ::InstructionType::CMP
            execution_object.fix_cr
            if execution_object.instruction.extra
                x = ::Letter.empty_letter
                execution_object.set_cr(tape.compare(x))
            else
                x = ::Letter.character_letter(execution_object.instruction.letter)
                execution_object.set_cr(tape.compare(x))
            end
            execution_object.increment_ir
        when ::InstructionType::DRAW
            if execution_object.alphabeth.includes?(execution_object.instruction.letter)
                if execution_object.instruction.extra
                    tape.draw(::Letter.empty_letter)
                else
                    tape.draw(::Letter.character_letter(execution_object.instruction.letter))
                end
            else
                Log.error { "Quitting program due to: ::Letter #{execution_object.instruction.letter} is not in alphabeth"}
                execution_object.done = true
                execution_object.end_message = ::EndMessage::FAIL
            end
            execution_object.increment_ir
        end
    end 
end