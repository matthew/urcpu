require File.expand_path(File.dirname(__FILE__) + "/../../../../spec_helper")

describe UrCPU::Assembler::Parser::Result::AbstractValue do
  before do
    @klass = UrCPU::Assembler::Parser::Result::AbstractValue
    @value = {:i => 'am', :a => :value}
    @result = @klass.new([@value])
  end
  
  describe "#value" do
    it "knows its value" do
      @result.value.should == @value
    end
  end
  
  describe "#==" do
    before do
      @same = @klass.new([@value])
      @not_same = @klass.new(["different"])
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