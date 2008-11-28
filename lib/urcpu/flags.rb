module UrCPU
  class Flags < Slots
    FLAGS = [:zf]
    
    def self.slots
      FLAGS
    end
    
    def initialize
      super(false)
    end
  end
end