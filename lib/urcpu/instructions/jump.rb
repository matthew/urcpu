module Instructions
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
end