module Instructions
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
end