module UrCPU
  class Assembler
    class Parser
      class Token
        include Debug

        attr_reader :name
        
        class << self
          def register(*args, &block)
            Token.save new(*args, &block)
          end
          
          def lookup(name)
            if token = registry[name]
              token
            else
              raise UrCPU::ParseError, "Unknown token: #{name.inspect}"
            end
          end
          
          def save(token)
            registry[token.name] = token
          end

          private
          
          def registry
            @registry ||= Hash.new
          end
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
          Array(
            serializer ? serializer.call(*captures) : nil
          )
        end
      end
    end
  end
end