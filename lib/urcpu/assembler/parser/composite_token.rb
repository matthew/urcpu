module UrCPU
  class Assembler
    class Parser
      class CompositeToken < Token
        attr_reader :tokens
        
        def initialize(name, tokens)
          @name = name
          @tokens = tokens
        end
        
        def match(line)
          tokens.each do |token|
            if matches = token.match(line)
              return matches
            end
          end
          
          nil
        end
      end
    end
  end
end