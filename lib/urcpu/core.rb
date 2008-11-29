module UrCPU
  class Core
    attr_reader :registers, :memory, :os
    
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
    
    def jmp_lbl
      label = read_instruction
      registers[:eip] = memory.label(label)
    end

    def jz_lbl
      label = read_instruction
      if registers.flags[:zf]
        registers[:eip] = memory.label(label)
      end
    end
    alias :je_lbl :jz_lbl

    def jnz_lbl
      label = read_instruction
      unless registers.flags[:zf]
        registers[:eip] = memory.label(label)
      end
    end
    alias :jne_lbl :jnz_lbl
    
    def cmp_imm_reg
      imm, reg = read_instructions(2)
      registers.flags[:zf] = (imm == registers[reg])
    end
    
    def push_imm
      push read_instruction
    end

    def push_reg
      push registers[read_instruction]
    end

    def pop_reg
      pop read_instruction
    end
    
    def call_lbl
      label = read_instruction
      push registers[:eip]
      registers[:eip] = memory.label(label)
    end
    
    def ret
      pop :eip
    end
    
    def hlt
      @halted = true
    end
    
    private
    
    def push(val)
      memory[registers[:esp]] = val
      registers[:esp] += 1
    end

    def pop(reg)
      registers[:esp] -= 1
      registers[reg] = memory[registers[:esp]]
    end
  end
end