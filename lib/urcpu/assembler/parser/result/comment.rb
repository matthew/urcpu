module UrCPU
  class Assembler
    class Parser
      module Result
        class Comment
          def initialize(_)
          end
        
          def ==(other)
            other.kind_of? Comment
          end
        end
      end
    end
  end
end