module UrCPU
  class Assembler
    class Parser
      module Token
        class Immediate < Base
          def initialize(name)
            super(name, regex)
          end
        
          private
        
          def regex
            /
              \$                      # Immediates start with a $
              (?:
                  (-?                 # Immediate can be negative
                    (?:
                        0x[\dA-Fa-f]+ # Immediate can be a base 16 number
                      | \d+           # Immediate can be a base 10 number
                    )
                  ) 
                | (\w+)               # Immediate can be a label
              )\b                     # Immediates are followed by a boundry
            /x
          end
        
          def serializer
            Proc.new do |imm_number, imm_label|
              imm_number ? eval(imm_number) : imm_label.to_sym
            end
          end
        end
      end
    end
  end
end