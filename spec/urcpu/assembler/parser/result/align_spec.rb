require File.expand_path(File.dirname(__FILE__) + "/../../../../spec_helper")

describe UrCPU::Assembler::Parser::Result::Align do
  before do
    @align = 6
    @result = UrCPU::Assembler::Parser::Result::Align.new([@align])
  end
  
  describe "#align" do
    it "knows its align" do
      @result.align.should == @align
    end
  end
  
  describe "#==" do
    before do
      @same = UrCPU::Assembler::Parser::Result::Align.new([@align])
      @not_same = UrCPU::Assembler::Parser::Result::Align.new([97])
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