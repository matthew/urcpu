module UrCPU
  class Assembler
    class Parser
      class LineParser
        include Debug
        
        attr_reader :result_klass, :tokens
      
        def initialize(result_klass, token_names)
          @result_klass = result_klass
          @tokens = token_names.map { |name| Token.lookup(name) }
        end
        
        def match(line)
          debug "TRYING LineParser result_klass=#{result_klass}"
          line_to_parse = line.clone
          
          all_matches = tokens.inject([]) do |all_matches, token|
            if matches = token.match(line_to_parse)
              all_matches + matches
            else
              return nil
            end
          end
          
          debug
          line_to_parse.empty? ? result_klass.new(all_matches) : nil
        end
      end
    end
  end
end