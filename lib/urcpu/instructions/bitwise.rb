module Instructions
  def xor_reg_reg
    reg1, reg2 = read_instructions(2)
    registers[reg2] ^= registers[reg1]
  end
end