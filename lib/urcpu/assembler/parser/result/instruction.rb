module UrCPU
  class Assembler
    class Parser
      module Result
        class Instruction
          attr_reader :ins, :operands
        
          def initialize(parsed_data)
            @ins, op1, op2 = parsed_data
            @operands = [op1, op2].compact
          end
        
          def airity
            @operands.size
          end
        
          def ==(other)
            ins == other.ins && operands == other.operands
          end
        end
      end
    end
  end
end