module TuringVM
    def parse_binary(file_path : String) : Array(UInt16)
        # Parses binary file into an array of type UInt16 of instructions
        if file_path == ""
            Log.fatal { "No input argument is given"}
            exit(1)
        end
        unless File.file?(file_path)
            Log.fatal { "Binary file at #{file_path} could not be found"}
            exit(1)
        end
        size : Int32 = 2^12
        ram = Array(UInt16).new(size)
        Log.info { "Importing program from #{file_path}"}
        File.open(file_path, "rb") do |stream|
                (stream.size//2).times do
                ram.push(stream.read_bytes(UInt16))
            end
        end
        return ram
    end

    def parse_tape_file(file_path : String) : Array(String)
        # Parses tape file into array of strings ( splits the string in the file by new lines )
        if file_path == ""
            Log.fatal { "No tape file argument is given"}
            exit(1)
        end
        unless File.file?(file_path)
            Log.fatal { "Tape file at #{file_path} could not be found"}
            exit(1)
        end
        Log.info { "Importing tape from #{file_path}"}
        tape_array = File.read(file_path).split('\n')
        tape_array.each do |array|
            unless array.size > 0
                Log.warn { "Deleting empty tape line" }
                tape_array.delete(array)
            end
        end
        return tape_array
    end
end