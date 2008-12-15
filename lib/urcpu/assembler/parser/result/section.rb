module UrCPU
  class Assembler
    class Parser
      module Result
        class Section < AbstractValue
          alias :section :value
        end
      end
    end
  end
end