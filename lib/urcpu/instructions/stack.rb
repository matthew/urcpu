module Instructions
  def push_imm
    push read_instruction
  end

  def push_reg
    push registers[read_instruction]
  end

  def pop_reg
    pop read_instruction
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