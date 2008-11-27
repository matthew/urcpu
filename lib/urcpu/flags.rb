module UrCPU
  class Flags < SlotContainer
    FLAGS = [:zf]
    
    def self.slots
      FLAGS
    end
    
    def initialize
      super(false)
    end
  end
end