require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe UrCPU::Assembler::Parser::LabelResult do
  before do
    @result = UrCPU::Assembler::Parser::LabelResult.new([:some_label])
  end
  
  describe "#label" do
    it "knows its label" do
      @result.label.should == :some_label
    end
  end
  
  describe "#==" do
    before do
      @same = UrCPU::Assembler::Parser::LabelResult.new([:some_label])
      @not_same = UrCPU::Assembler::Parser::LabelResult.new([:different])
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