module Instructions
  def call_lbl
    label = read_instruction
    push registers[:eip]
    registers[:eip] = memory.label(label)
  end

  def ret
    pop :eip
  end
end

