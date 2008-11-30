module Instructions
  def int_imm
    case interrupt = read_instruction
    when 0x80
      os.dispatch_syscall
    else
      raise UrCPU::BusError, "Unknown interrupt: #{interrupt.inspect}"
    end
  end
end


