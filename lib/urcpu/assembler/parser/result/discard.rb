module UrCPU
  class Assembler
    class Parser
      module Result
        class Discard
          def initialize(_)
          end
        
          def ==(other)
            other.kind_of? Discard
          end
        end
      end
    end
  end
end