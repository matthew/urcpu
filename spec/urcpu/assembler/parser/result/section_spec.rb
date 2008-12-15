require File.expand_path(File.dirname(__FILE__) + "/../../../../spec_helper")

describe UrCPU::Assembler::Parser::Result::Section do
  before do
    @section = :some_section
    @result = UrCPU::Assembler::Parser::Result::Section.new([@section])
  end
  
  describe "#section" do
    it "knows its section" do
      @result.section.should == @section
    end
  end
  
  describe "#==" do
    before do
      @same = UrCPU::Assembler::Parser::Result::Section.new([@section])
      @not_same = UrCPU::Assembler::Parser::Result::Section.new([:other_sec])
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