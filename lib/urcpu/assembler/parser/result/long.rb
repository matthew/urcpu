module UrCPU
  class Assembler
    class Parser
      module Result
        class Long < AbstractValue
          alias :long :value
        end
      end
    end
  end
end