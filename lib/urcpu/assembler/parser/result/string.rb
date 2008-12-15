module UrCPU
  class Assembler
    class Parser
      module Result
        class String < AbstractValue
          alias :string :value
        end
      end
    end
  end
end