module Instructions
  def cmp_imm_reg
    imm, reg = read_instructions(2)
    registers.flags[:zf] = (imm == registers[reg])
  end
end