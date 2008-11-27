require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe UrCPU::Registers do
  before do
    @registers = UrCPU::Registers.new
  end
  
  describe "register access by [] and method" do
    UrCPU::Registers::REGISTERS.each do |register|
      it "#[#{register}] #[#{register}]=" do
        @registers[register].should == 0
        @registers[register] = 5
        @registers[register].should == 5
      end
    end
  end
  
  describe "#flags" do
    it "should have a flags object" do
      @registers.flags.should_not be_nil
      @registers.flags[:zf].should be_false
    end
  end
  
  describe "#reset" do
    it "should reset the registers and the flags" do
      mock(@registers.flags).reset!
      UrCPU::Registers::REGISTERS.each do |register|
        mock(@registers)[register] = 0
      end
      @registers.reset!
    end
  end
end