module TuringVM
    # Types of supported operations
    enum InstructionType
        LEFT # Moving tape head to the left
        RIGHT # Moving tape head to the right
        HALT # Finishing program with HALT status
        FAIL # Finishing program with FAIL status
        DRAW # Drawing given letter to the tape on current postion
        ALPHA # Adding/removing given letter to/from the alphabeth
        BRAE # If compare register is set to true goes to the given instruction in RAM
        BRANE # If compare register is set to false goes to the given instruction in RAM
        BRA # Goes to the given instruction in RAM independent of the content of CMP register
        CMP # Compares current letter at the tape position with the given one
    end
end