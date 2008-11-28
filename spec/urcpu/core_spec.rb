require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe UrCPU::Core do
  before do
    memory = UrCPU::Memory.new
    @program = [
      :mov_imm_reg, 2, :eax,
      :mov_imm_reg, 5, :ebx,
      :add_reg_reg, :eax, :ebx,
    ]
    memory.concat @program
    memory.section("data")
    memory.section("stack")

    @cpu = UrCPU::Core.new(memory)
  end
  
  describe "associated objects" do
    it "should have registers" do
      @cpu.registers.should_not be_nil
    end
    
    it "should have memory" do
      @cpu.memory.should_not be_nil
    end
    
    it "should have an OS" do
      @cpu.os.should_not be_nil
    end
  end
  
  describe "#read_instruction" do
    it "should increment the EIP register" do
      @cpu.registers[:eip].should == 0
      @cpu.read_instruction.should == :mov_imm_reg
      @cpu.registers[:eip].should == 1
    end
  end
  
  describe "#read_instructions" do
    it "returns nothing and not increment EIP for N=0" do
      @cpu.registers[:eip].should == 0
      @cpu.read_instructions(0).should == []
      @cpu.registers[:eip].should == 0
    end

    it "returns one instruction and increments EIP by for N=1" do
      @cpu.registers[:eip].should == 0
      @cpu.read_instructions(1).should == [:mov_imm_reg]
      @cpu.registers[:eip].should == 1
    end
    
    it "should return N items and increment EIP register by N" do
      n = @program.length
      @cpu.registers[:eip].should == 0
      @cpu.read_instructions(n).should == @program
      @cpu.registers[:eip].should == n
    end
  end
  
  describe "#mov" do
    describe "immediate/register" do
      it "moves the value into the register" do
        setup_cpu(:ebx => 0, :program => [97, :ebx])
        mock.proxy(@cpu).read_instructions(2)
        @cpu.mov_imm_reg
        @cpu.registers[:ebx].should == 97
      end
    end

    describe "register/register" do
      it "moves the value at reigster1 into register2" do
        setup_cpu(:eax => 97, :ebx => 101, :program => [:eax, :ebx])
        mock.proxy(@cpu).read_instructions(2)
        @cpu.mov_reg_reg
        @cpu.registers[:eax].should == 97
        @cpu.registers[:ebx].should == 97
      end
    end
  end

  describe "#add" do
    describe "immediate/register" do
      it "adds the value to the register" do
        setup_cpu(:ebx => 101, :program => [97, :ebx])
        mock.proxy(@cpu).read_instructions(2)
        @cpu.add_imm_reg
        @cpu.registers[:ebx].should == 97 + 101
      end
    end

    describe "register/register" do
      it "adds the value at reigster1 into register2" do
        setup_cpu(:eax => 97, :ebx => 101, :program => [:eax, :ebx])
        mock.proxy(@cpu).read_instructions(2)
        @cpu.add_reg_reg
        @cpu.registers[:eax].should == 97
        @cpu.registers[:ebx].should == 97 + 101
      end
    end
  end
  
  describe "#sub" do
    describe "immediate/register" do
      it "subtracts the value from the register" do
        setup_cpu(:ebx => 101, :program => [97, :ebx])
        mock.proxy(@cpu).read_instructions(2)
        @cpu.sub_imm_reg
        @cpu.registers[:ebx].should == 101 - 97
        @cpu.registers.flags[:zf].should be_false
      end
      
      it "sets the zero flag if the register becomes 0" do
        setup_cpu(:ebx => 97, :program => [97, :ebx])
        mock.proxy(@cpu).read_instructions(2)
        @cpu.sub_imm_reg
        @cpu.registers[:ebx].should == 0
        @cpu.registers.flags[:zf].should be_true
      end
    end

    describe "register/register" do
      it "subtracts register1 from register2" do
        setup_cpu(:eax => 97, :ebx => 101, :program => [:eax, :ebx])
        mock.proxy(@cpu).read_instructions(2)
        @cpu.sub_reg_reg
        @cpu.registers[:eax].should == 97
        @cpu.registers[:ebx].should == 4
        @cpu.registers.flags[:zf].should be_false
      end

      it "sets the zero flag if register2 becomes 0" do
        setup_cpu(:eax => 97, :ebx => 97, :program => [:eax, :ebx])
        mock.proxy(@cpu).read_instructions(2)
        @cpu.sub_reg_reg
        @cpu.registers[:eax].should == 97
        @cpu.registers[:ebx].should == 0
        @cpu.registers.flags[:zf].should be_true
      end
    end
  end
  
  describe "#int_imm" do
    it "passes the interrupt to the OS if its 0x80" do
      setup_cpu(:program => [0x80])
      mock.proxy(@cpu).read_instructions(1)
      mock(@cpu.os).dispatch_syscall
      @cpu.int_imm
    end
    
    it "gives a bus error if the interrupt is unknown" do
      setup_cpu(:program => [0x0])
      mock.proxy(@cpu).read_instructions(1)
      lambda { @cpu.int_imm }.should raise_error(UrCPU::BusError)
    end
  end
  
  describe "#jmp_lbl" do
    it "changes EIP to the memory address associated with the given label" do
      setup_cpu(:eip => 0, :program => [:test_label])
      mock(@cpu.memory).label(anything) { 97 }
      @cpu.jmp_lbl
      @cpu.registers[:eip].should == 97
    end
  end
  
  describe "#jz_lbl" do
    it "changes EIP to the labeled address if ZF is true" do
      setup_cpu(:eip => 0, :zf => true, :program => [:test_label])
      stub(@cpu.memory).label(anything) { 97 }
      @cpu.jz_lbl
      @cpu.registers[:eip].should == 97
    end

    it "does not change EIP to the labeled address if ZF is false" do
      setup_cpu(:eip => 0, :zf => false, :program => [:test_label])
      stub(@cpu.memory).label(anything) { 97 }
      @cpu.jz_lbl
      @cpu.registers[:eip].should_not == 97
    end
  end
end