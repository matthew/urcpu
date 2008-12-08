module UrCPU
  class Assembler
    class Parser
      class LabelResult
        attr_reader :label
        
        def initialize(label)
          @label = label.first
        end

        def ==(other)
          label == other.label
        end
      end
    end
  end
end