module UrCPU
  class Core
    attr_reader :registers, :memory, :os
    
    def initialize(memory)
      @memory = memory
      @registers = Registers.new
      @os = OS.new(self)
      registers[:eip] = memory.section("text")
      registers[:ebp] = memory.section("data")
      registers[:esp] = memory.section("stack")
    end
    
    def read_instruction
      read_instructions(1).first
    end
    
    def read_instructions(count)
      instructions = memory[registers[:eip], count]
      registers[:eip] += count
      instructions
    end
    
    def mov_imm_reg
      imm, reg = read_instructions(2)
      registers[reg] = imm
    end

    def mov_reg_reg
      reg1, reg2 = read_instructions(2)
      registers[reg2] = registers[reg1]
    end

    def add_imm_reg
      imm, reg = read_instructions(2)
      registers[reg] += imm
    end

    def add_reg_reg
      reg1, reg2 = read_instructions(2)
      registers[reg2] += registers[reg1]
    end
    
    def sub_imm_reg
      value, reg = read_instructions(2)
      registers[reg] -= value
      registers.flags[:zf] = registers[reg].zero?
    end
    
    def sub_reg_reg
      reg1, reg2 = read_instructions(2)
      registers[reg2] -= registers[reg1]
      registers.flags[:zf] = registers[reg2].zero?
    end
    
    def int_imm
      case interrupt = read_instruction
      when 0x80
        os.dispatch_syscall
      else
        raise BusError, "Unknown interrupt: #{interrupt.inspect}"
      end
    end
  end
end