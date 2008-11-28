module UrCPU
  class Registers < Slots
    REGISTERS = [:eax, :ebx, :ecx, :edx, :esp, :ebp, :edi, :esi, :eip]
    attr_reader :flags

    def self.slots
      REGISTERS
    end
    
    def initialize
      @flags = Flags.new
      super(0)
    end
    
    def reset!
      super
      @flags.reset!
    end
  end
end