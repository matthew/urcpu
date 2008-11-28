require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe UrCPU::Slots do
  before do
    @slot_names = [:foo, :bar, :baz]
    stub(UrCPU::Slots).slots { @slot_names }
    @default = 97
    @slots = UrCPU::Slots.new(@default)
  end
  
  describe "register access by [] and method" do
    it "Slots are defaulted" do
      @slot_names.each do |slot|
        @slots[slot].should == @default
      end
    end
    
    it "allows writing to the Slots" do
      @slot_names.each do |slot|
        value = rand(100)
        @slots[slot] = value
        @slots[slot].should == value
      end
    end
    
    it "disallows reading from unknown Slots" do
      @slot_names.should_not be_include(:qux)
      lambda { @slots[:qux] }.should raise_error(ArgumentError)
    end

    it "disallows writing from unknown Slots" do
      @slot_names.should_not be_include(:qux)
      lambda { @slots[:qux] = 10 }.should raise_error(ArgumentError)
    end
  end
  
  describe "#reset!" do
    it "should set all flags back to false" do
      @slot_names.each do |slot|
        mock(@slots)[slot] = @default
      end
      @slots.reset!
    end
  end
  
  describe "#to_s" do
    it "should render itself with all the Slots" do
      @slots.to_s.should == "<foo:97 bar:97 baz:97>"
    end
  end
end