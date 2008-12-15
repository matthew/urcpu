module UrCPU
  class Assembler
    class Parser
      module Token
        class String < Base
          def initialize(name)
            super(name, regex)
          end
        
          private
        
          def regex
            /("(?:\\.|[^"\\])*")/
          end
          
          def serializer
            Proc.new do |string|
              eval string
            end
          end
        end
      end
    end
  end
end