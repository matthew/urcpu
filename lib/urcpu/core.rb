module UrCPU
  class Core
    attr_reader :registers, :memory, :os
    include Instructions

    def initialize(memory)
      @halted = false
      @memory = memory
      @registers = Registers.new
      @os = OS.new(self)
      registers[:eip] = memory.section("text")
      registers[:ebp] = memory.section("data")
      registers[:esp] = memory.section("stack")
    end
    
    def halted?
      @halted
    end
    
    def read_instruction
      read_instructions(1).first
    end
    
    def read_instructions(count)
      instructions = memory[registers[:eip], count]
      registers[:eip] += count
      instructions
    end
    
    def dispatch_instruction(instruction)
      if respond_to? instruction
        send(instruction)
      else
        raise IllegalInstruction, "Unknown instruction: #{instruction.inspect}"
      end
    end
    
    def run
      while !halted?
        dispatch_instruction read_instruction
      end
    end
  end
end