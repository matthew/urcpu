module UrCPU
  class Assembler
    class Parser
      module Result
        class String
          attr_reader :string
        
          def initialize(string)
            @string = string.first
          end

          def ==(other)
            string == other.string
          end
        end
      end
    end
  end
end