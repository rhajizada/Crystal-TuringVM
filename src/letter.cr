module TuringVM
    # Class that is used to work with letters
    # This allows us to support empty letters ( in theory tape is infinite )
    class Letter
        property is_empty : Bool
        property character : Char
        def initialize(character : Char, is_empty : Bool)
            @is_empty = is_empty
            @character = character
        end

        def ==(other : self) : Bool
            return other.is_empty == @is_empty && other.character == @character
        end

        def self.character_letter(character : Char) : self
            return self.new(character, false)
        end

        def self.character_letter(character : Nil)
        end
        
        def self.empty_letter : self
            return self.new('\u0000', true)
        end
    end
end