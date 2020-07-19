# TODO: Write documentation for `TuringVm`
require "option_parser"
require "logger"
require "./parser.cr"
require "./instruction_type.cr"
require "./tape.cr"
require "./instruction.cr"
require "./pipeline_operations.cr"
require "./execution_object.cr"
include TuringVM

module TuringVM
  VERSION = "0.1.0"
  binary_file_path  : String = ""
  tape_file_path  : String = ""
  Log.progname = "TuringVM"
  OptionParser.parse do |parser|
    parser.banner = "Usage: ./turing_vm [arguments]"
    parser.on("-i FILE", "--input=FILE", "Binary file that contains the program") { |input| binary_file_path = input}
    parser.on("-d", "--debug", "Debug mode") { Log.setup(:debug) }
    parser.on("-t FILE", "--tape=FILE", "Tape file that the program will run on") { |tape| tape_file_path = tape }
    parser.on("-h", "--help", "Show this help") do
      puts parser
      exit
    end
    parser.invalid_option do |flag|
      STDERR.puts "ERROR: #{flag} is not a valid option."
      STDERR.puts parser
      exit(1)
    end
  end
  ram = parse_binary(binary_file_path) # Reading the program into RAM
  array_of_tapes = parse_tape_file(tape_file_path) # Reading the tape that the program will execute on
  array_of_tapes.each.with_index do |tape_string, tape_index|
    spawn do # Taking advantage of concurrency, program will run each tape concurrently
      current_tape = Tape.new(tape_string) # Parsing tape string into tape object
      Fiber.current.name = "Worker #{tape_index}" # Naming our fibers e.g 'Worker 1'
      execution_object = ExecutionObject.new # Creating execution object that will run the program
      while !execution_object.done # While execution process is not finished running the program
        Log.debug { "Instruction is running on #{Fiber.current.name}" }
        ir = execution_object.ir # Getting the value of the Instruction Register
        instruction = fetch(ir, ram) #Fetching the current instruction to be executed from RAM
        instruction_object = decode(instruction) # Decoding the instruction
        execution_object.set_instruction(instruction_object) # Setting current instruction of ExecutionObject to previously decoded one
        execute(execution_object, current_tape) # Execution current instruction on the tape
        Log.debug { "Tape status :\n #{current_tape.to_s_with_head}"}
      end
      Log.info { "#{Fiber.current.name} finished executing program. #{execution_object.end_message} after #{execution_object.mc} moves and #{execution_object.ic} instructions executed\n#{current_tape.to_s_with_head}" }
    end
    Fiber.yield
  end
end