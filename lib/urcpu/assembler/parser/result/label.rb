module UrCPU
  class Assembler
    class Parser
      module Result
        class Label < AbstractValue
          alias :label :value
        end
      end
    end
  end
end