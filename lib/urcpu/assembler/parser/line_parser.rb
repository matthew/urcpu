module UrCPU
  class Assembler
    class Parser
      class LineParser
        include Debug
        
        attr_reader :result_klass, :tokens
      
        def initialize(result_klass, token_names)
          @result_klass = result_klass
          @tokens = lookup_tokens token_names
        end
        
        def lookup_tokens(names)
          names.map do |name|
            case name
            when Symbol: Token.lookup(name)
            when String: Token::Base.new(name, Regexp.escape(name))
            else
              raise UrCPU::ParseError, "Unknown token name: #{name.inspect}"
            end
          end
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