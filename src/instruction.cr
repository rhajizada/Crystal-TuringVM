require "./instruction_type.cr"
require "log"

module TuringVM
    # Parsing instruction code into actual instruction object
    class Instruction
        property opt_type : InstructionType
        property address : UInt16?
        property letter : Char?
        property extra : Bool?
        def initialize(instruction_code : UInt16)
            address_mask : UInt16 = 0b0000111111111111
            letter_mask : UInt16 = 0b0000000011111111
            extra_mask : UInt16 = 0b00001
            @opt_type = InstructionType.new((instruction_code >> 12).to_i())
            if @opt_type == InstructionType::BRAE || @opt_type == InstructionType::BRANE || @opt_type == InstructionType::BRA
                @address = (instruction_code & address_mask)
            elsif @opt_type == InstructionType::DRAW || @opt_type == InstructionType::ALPHA || @opt_type == InstructionType::CMP
                @letter = (instruction_code & letter_mask).chr
                @extra = (instruction_code>>11 & extra_mask) == 1
            end
        end

        def to_s : String
            # Retuns current instruction as a string
            return "#{@opt_type} #{@address} #{@letter} #{@extra}"
        end
    end
end