require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe UrCPU::Core do
  before do
    memory = UrCPU::Memory.new
    memory.start_text!
    @program = [
      :mov_imm_reg, 2, :eax,
      :mov_imm_reg, 5, :ebx,
      :add_reg_reg, :eax, :ebx,
    ]
    memory.concat @program
    memory.start_data!
    memory.start_stack!

    @cpu = UrCPU::Core.new(memory)
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
        @cpu.mov_imm_reg
        @cpu.registers[:ebx].should == 97
      end
    end

    describe "register/register" do
      it "moves the value at reigster1 into register2" do
        setup_cpu(:eax => 97, :ebx => 101, :program => [:eax, :ebx])
        @cpu.mov_reg_reg
        @cpu.registers[:eax].should == 97
        @cpu.registers[:ebx].should == 97
      end
    end
  end

  describe "#add" do
    describe "immediate/register" do
      it "moves the value into the register" do
        setup_cpu(:ebx => 101, :program => [97, :ebx])
        @cpu.add_imm_reg
        @cpu.registers[:ebx].should == 97 + 101
      end
    end

    describe "register/register" do
      it "moves the value at reigster1 into register2" do
        setup_cpu(:eax => 97, :ebx => 101, :program => [:eax, :ebx])
        @cpu.add_reg_reg
        @cpu.registers[:eax].should == 97
        @cpu.registers[:ebx].should == 97 + 101
      end
    end
  end
end