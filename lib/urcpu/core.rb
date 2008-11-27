module UrCPU
  class Core
    attr_reader :registers, :memory
    
    def initialize(memory)
      @memory = memory
      @registers = Registers.new
      registers[:eip] = memory.text_start
      registers[:ebp] = memory.data_start
      registers[:esp] = memory.stack_start
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
  end
end