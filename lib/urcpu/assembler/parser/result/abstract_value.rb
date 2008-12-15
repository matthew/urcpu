module UrCPU
  class Assembler
    class Parser
      module Result
        class AbstractValue < Struct.new(:value)
          def initialize(values)
            super(values.first)
          end
        end
      end
    end
  end
end