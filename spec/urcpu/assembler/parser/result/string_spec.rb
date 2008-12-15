require File.expand_path(File.dirname(__FILE__) + "/../../../../spec_helper")

describe UrCPU::Assembler::Parser::Result::String do
  before do
    @string = "I like \"cows\" and \t and \n so much"
    @result = UrCPU::Assembler::Parser::Result::String.new([@string])
  end
  
  describe "#string" do
    it "knows its string" do
      @result.string.should == @string
    end
  end
  
  describe "#==" do
    before do
      @same = UrCPU::Assembler::Parser::Result::String.new([@string])
      @not_same = UrCPU::Assembler::Parser::Result::String.new(["different"])
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