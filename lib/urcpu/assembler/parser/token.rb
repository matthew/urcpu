module UrCPU
  class Assembler
    class Parser
      class Token
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
            debug "MATCH: token=#{name} match=#{match} captures=#{match.captures.inspect} line=#{line}"
            line.gsub!(match_regex, "")
            serialize match.captures
          else
            debug "NO MATCH: token=#{name} line=#{line}"
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
        
        def debug(str = "")
          puts str if $URCPU_DEBUG
        end
      end
    end
  end
end