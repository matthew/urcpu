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
                   ~?                 # Immediate can be bitwise negated
                    (?:
                        0x[\dA-Fa-f]+ # Immediate can be a base 16 number
                      | \d+           # Immediate can be a base 10 number
                    )
                  ) 
                | (\w+)               # Immediate can be a label
                | '(\w)               # Immediate can be a character
              )\b                     # Immediates are followed by a boundry
            /x
          end
        
          def serializer
            Proc.new do |imm_number, imm_label, imm_char|
              if imm_number
                eval(imm_number)
              elsif imm_label
                imm_label.to_sym
              elsif imm_char
                imm_char[0]
              end
            end
          end
        end
      end
    end
  end
end