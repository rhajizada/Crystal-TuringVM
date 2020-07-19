require "./instruction_type.cr"
module TuringVM
    # EndMessage defines the end message with wich program will end
    enum EndMessage
        HALT = InstructionType::HALT # Program finished successfully
        FAIL = InstructionType::FAIL # Program had an error and could not be finished
    end
end