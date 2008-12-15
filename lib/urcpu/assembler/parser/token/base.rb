module UrCPU
  class Assembler
    class Parser
      module Token
        class Base
          include Parser::Debug

          attr_reader :name
        
          def self.register(*args, &block)
            Token.save new(*args, &block)
          end
      
          def initialize(name, regex, &block)
            @name = name
            @regex = regex
            @serializer = block
          end
      
          def match(line)
            if match = line.match(match_regex)
              debug "MATCH #{name}: match=#{match.to_s.inspect} " +
                    "captures=#{match.captures.inspect} line=#{line.inspect}"
              line.gsub!(match_regex, "")
              serialize match.captures
            else
              debug "NO MATCH #{name}: line=#{line.inspect}"
              nil
            end
          end
      
          private
        
          attr_reader :regex, :serializer
      
          def match_regex
            /^#{regex}/
          end
      
          def serialize(captures)
            coerce_array(serializer ? serializer.call(*captures) : nil)
          end
          
          def coerce_array(value)
            (value == "") ? [""] : Array(value)
          end
        end
      end
    end
  end
end