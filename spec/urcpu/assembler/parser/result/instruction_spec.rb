require File.expand_path(File.dirname(__FILE__) + "/../../../../spec_helper")

describe UrCPU::Assembler::Parser::Result::Instruction do
  before do
    @klass = UrCPU::Assembler::Parser::Result::Instruction 
    @ins2 = @klass.new([:mov, 97, :eax])
    @ins1 = @klass.new([:push, 5])
    @ins0 = @klass.new([:ret])
  end
  
  describe "#ins" do
    it "knows its instruction" do
      @ins2.ins.should == :mov
      @ins1.ins.should == :push
      @ins0.ins.should == :ret
    end
  end

  describe "#operands" do
    it "knows its operands" do
      @ins2.operands.should == [97, :eax]
      @ins1.operands.should == [5]
      @ins0.operands.should == []
    end
  end

  describe "#airity" do
    it "knows its airity" do
      @ins2.airity.should == 2
      @ins1.airity.should == 1
      @ins0.airity.should == 0
    end
  end
  
  describe "#==" do
    before do
      @same2 = @klass.new([:mov, 97, :eax])
      @same1 = @klass.new([:push, 5])
      @same0 = @klass.new([:ret])
      @not_same2 = @klass.new([:add, 5, :eax])
      @not_same1 = @klass.new([:pop, :eax])
      @not_same0 = @klass.new([:nop])
    end
    
    it "is equal to itself" do
      @ins2.should == @ins2
      @ins1.should == @ins1
      @ins0.should == @ins0
    end

    it "is equal when instructions and operands are the same" do
      @ins2.should == @same2
      @ins1.should == @same1
      @ins0.should == @same0
    end
    
    it "is not equal when instructions and operands are not the same" do
      @ins2.should_not == @not_same2
      @ins1.should_not == @not_same1
      @ins0.should_not == @not_same0
    end
  end
end