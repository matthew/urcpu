module UrCPU
  class Assembler
    class Parser
      class Token
        attr_reader :name
      
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