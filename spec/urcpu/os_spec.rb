require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe UrCPU::OS do
  before do
    @os = UrCPU::OS.new(setup_cpu)
  end
  
  describe "#dispatch_syscall" do
    it "dispatches a known system call" do
      mock(UrCPU::OS::SYSTEM_CALLS).__send__(:[], 97) { :some_method }
      mock(@os).send(:some_method)
      @os.dispatch_syscall(97)
    end

    it "gives rise to an error if the system call is unknown" do
      lambda do
        @os.dispatch_syscall(-1)
      end.should raise_error(UrCPU::UnknownSystemCall)
    end
  end
  
  describe "#halt" do
    it "halts" do
      mock(@os).puts(anything)
      mock(@os).exit(true)
      @os.halt
    end
  end

  describe "#sys_write" do
    before do
      @msg = "Hello World!\n"
      @bytes = @msg.split(//).map {|char| char[0]}
      @cpu = setup_cpu(
        :ebx => 3,
        :ecx => @msg.length,
        :program => [nil]*3 + @bytes + [nil]*3
      )
      @os = UrCPU::OS.new(@cpu)
    end
    
    it "writes the message" do
      mock($stdout).print(@msg)
      @os.sys_write
    end
    
    it "gets a bus error if we read into nils" do
      mock(@cpu.memory).__send__(:[], anything) { nil }
      lambda { @os.sys_write }.should raise_error(UrCPU::BusError)
    end
  end
end