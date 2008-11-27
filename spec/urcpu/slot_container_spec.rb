require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe UrCPU::SlotContainer do
  before do
    @slots = [:foo, :bar, :baz]
    stub(UrCPU::SlotContainer).slots { @slots }
    @default = 97
    @slot_container = UrCPU::SlotContainer.new(@default)
  end
  
  describe "register access by [] and method" do
    it "slots are defaulted" do
      @slots.each do |slot|
        @slot_container[slot].should == @default
      end
    end
    
    it "allows writing to the slots" do
      @slots.each do |slot|
        value = rand(100)
        @slot_container[slot] = value
        @slot_container[slot].should == value
      end
    end
    
    it "disallows reading from unknown slots" do
      @slots.should_not be_include(:qux)
      lambda { @slot_container[:qux] }.should raise_error(ArgumentError)
    end

    it "disallows writing from unknown slots" do
      @slots.should_not be_include(:qux)
      lambda { @slot_container[:qux] = 10 }.should raise_error(ArgumentError)
    end
  end
  
  describe "#reset!" do
    it "should set all flags back to false" do
      @slots.each do |slot|
        mock(@slot_container)[slot] = @default
      end
      @slot_container.reset!
    end
  end
  
  describe "#to_s" do
    it "should render itself with all the slots" do
      @slot_container.to_s.should == "<foo:97 bar:97 baz:97>"
    end
  end
end