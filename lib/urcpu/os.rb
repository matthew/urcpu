module UrCPU
  class OS
    SYSTEM_CALLS = {
      1 => :halt,
      2 => :sys_write,
    }
    
    def initialize(cpu)
      @cpu = cpu
    end
    
    def dispatch_syscall(syscall)
      os_method = SYSTEM_CALLS[syscall]
      raise UnknownSystemCall, syscall.inspect if os_method.nil?
      send(os_method)
    end
    
    def halt
      puts "Halting!"
      exit true
    end
    
    def sys_write
      msg_ptr = @cpu.registers[:ebx]
      msg_len = @cpu.registers[:ecx]
      
      msg = ""
      msg_len.times do |n|
        byte = @cpu.memory[msg_ptr + n]
        raise BusError, "sys_write over read" if byte.nil?
        msg += byte.chr
      end
      
      $stdout.print msg
    end
  end
end