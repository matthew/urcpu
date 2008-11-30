module Instructions
  def mov_imm_reg
    imm, reg = read_instructions(2)
    registers[reg] = imm
  end

  def mov_reg_reg
    reg1, reg2 = read_instructions(2)
    registers[reg2] = registers[reg1]
  end
end