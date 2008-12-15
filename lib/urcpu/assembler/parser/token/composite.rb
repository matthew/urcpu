module UrCPU
  class Assembler
    class Parser
      module Token
        class Composite < Base
          attr_reader :tokens
        
          def initialize(name, tokens)
            @name = name
            @tokens = tokens
          end
        
          def match(line)
            debug "== Composite Token START == "
            matches = match_without_debug(line)
            debug "== Composite Token END == "
            matches
          end
        
          def match_without_debug(line)
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
end