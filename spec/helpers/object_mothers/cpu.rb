def setup_cpu(options={})
  memory = UrCPU::Memory.new(options.delete(:program))
  @cpu = UrCPU::Core.new(memory)
  @cpu.registers.reset!
  options.each do |name, value|
    if UrCPU::Registers::REGISTERS.include? name
      @cpu.registers[name] = value
    elsif UrCPU::Flags::FLAGS.include? name
      @cpu.registers.flags[name] = value
    else
      raise ArgumentError, "Unknown setup_cpu option: #{name.inspect}"
    end
  end
end