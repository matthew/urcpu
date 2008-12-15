module UrCPU
  class Assembler
    class Parser
      module Result
        class Long
          attr_reader :long
        
          def initialize(long)
            @long = long.first
          end

          def ==(other)
            long == other.long
          end
        end
      end
    end
  end
end