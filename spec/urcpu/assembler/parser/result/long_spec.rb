require File.expand_path(File.dirname(__FILE__) + "/../../../../spec_helper")

describe UrCPU::Assembler::Parser::Result::Long do
  before do
    @long = 0xDEADBEEF
    @result = UrCPU::Assembler::Parser::Result::Long.new([@long])
  end
  
  describe "#long" do
    it "knows its long" do
      @result.long.should == @long
    end
  end
  
  describe "#==" do
    before do
      @same = UrCPU::Assembler::Parser::Result::Long.new([@long])
      @not_same = UrCPU::Assembler::Parser::Result::Long.new([0xFEED])
    end
    
    it "is equal to itself" do
      @result.should == @result
    end

    it "is equal when labels are the same" do
      @result.should == @same
    end
    
    it "is not equal when labels are different" do
      @result.should_not == @not_same
    end
  end
end