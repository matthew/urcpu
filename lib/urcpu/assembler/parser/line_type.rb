module UrCPU
  class Assembler
    class Parser
      class LineType
        attr_reader :type, :tokens
      
        def initialize(type, token_names)
          @type = type
          @tokens = token_names.map { |name| lookup_token(name) }
        end
        
        def match(line)
          line_to_parse = line.clone
          
          all_matches = tokens.inject([]) do |all_matches, token|
            if matches = token.match(line_to_parse)
              all_matches + matches
            else
              return nil
            end
          end
          
          line_to_parse.empty? ? all_matches : nil
        end

        private
        
        def parser_tokens
          TOKENS + OPERANDS
        end
        
        def lookup_token(name)
          if token = parser_tokens.find { |token| token.name == name }
            token
          else
            raise UrCPU::ParseError, "Unknown token: #{name.inspect}"
          end
        end
      end
    end
  end
end