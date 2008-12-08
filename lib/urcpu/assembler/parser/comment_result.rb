module UrCPU
  class Assembler
    class Parser
      class CommentResult
        def initialize(_)
        end
        
        def ==(other)
          other.kind_of? CommentResult
        end
      end
    end
  end
end