module UrCPU
  class Assembler
    class Parser
      module Token
        class Arithmetic < Base
          def initialize(name)
            super(name, regex)
          end
        
          private
          
          def imm_or_num_rx
            /
              \$?                     # Immediates start with a $, nums don't
              (?:
                  (-?                 # can be negative
                    (?:
                        0x[\dA-Fa-f]+ # can be a base 16
                      | \d+           # can be a base 10
                    )
                  ) 
              )\b                     # followed by a boundry
            /x
          end
        
          def regex
            /
              (?:                # LHS of Operation
                #{imm_or_num_rx}     # Immediate or number, imm
                \s* (\+|\*) \s*      # Addition or Multiplication, op
              )?
              (?:                # RHS of Operation
                #{imm_or_num_rx}     # Immediate or number, base
                (?:                  # Bitwise left shift clause
                  \s* << \s*           # Shift operator
                  (\d+)                # Shift amount, shift
                )?     
              )
            /x
          end
        
          def serializer
            Proc.new do |imm, op, base, shift|
              lhs = eval(imm.to_s).to_i
              rhs = (eval(base.to_s).to_i << shift.to_i)
              case op
              when '+': lhs + rhs
              when '*': lhs * rhs
              when nil: rhs
              end
            end
          end
        end
      end
    end
  end
end