module UrCPU
  class Assembler
    class Parser
      class ArithmeticToken < Token
        def initialize(name)
          super(name, regex)
        end
        
        private
        
        def regex
          imm_or_num = /\$?(-?\d+(?:x\d+)?)/x
          /
            (?:               # Possible offset clause
              #{imm_or_num}     # Immediate or number
              \s* \+ \s*        # Addition
            )?
            (?:               # Bitwise left shift clause
              #{imm_or_num}     # Immediate or number
              \s* << \s*        # Shift operator
              (\d+)             # Shift amount
            )
          /x
        end
        
        def serializer
          Proc.new do |imm, base, shift|
            eval(imm.to_s).to_i + (base.to_i << shift.to_i)
          end
        end
      end
    end
  end
end