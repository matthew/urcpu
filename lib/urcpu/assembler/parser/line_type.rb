module UrCPU
  class Assembler
    class Parser
      class LineType
        include Debug
        
        attr_reader :type, :tokens
      
        def initialize(type, token_names)
          @type = type
          @tokens = token_names.map { |name| Token.lookup(name) }
        end
        
        def match(line)
          debug "TRYING LineType #{type}"
          line_to_parse = line.clone
          
          all_matches = tokens.inject([]) do |all_matches, token|
            if matches = token.match(line_to_parse)
              all_matches + matches
            else
              return nil
            end
          end
          
          debug
          line_to_parse.empty? ? all_matches : nil
        end
      end
    end
  end
end