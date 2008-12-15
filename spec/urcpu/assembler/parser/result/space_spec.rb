require File.expand_path(File.dirname(__FILE__) + "/../../../../spec_helper")

describe UrCPU::Assembler::Parser::Result::Space do
  before do
    @space = 1024
    @result = UrCPU::Assembler::Parser::Result::Space.new([@space])
  end
  
  describe "#space" do
    it "knows its space" do
      @result.space.should == @space
    end
  end
  
  describe "#==" do
    before do
      @same = UrCPU::Assembler::Parser::Result::Space.new([@space])
      @not_same = UrCPU::Assembler::Parser::Result::Space.new([97])
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