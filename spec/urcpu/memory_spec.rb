require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe UrCPU::Memory do
  describe "#initialize" do
    it "takes on the values passed to it" do
      UrCPU::Memory.new.should be_empty
      UrCPU::Memory.new(nil).should be_empty
      UrCPU::Memory.new([1, 2, 3, 4]).should == [1, 2, 3, 4]
      UrCPU::Memory.new(1 .. 5).should == [1, 2, 3, 4, 5]
    end
    
    it "doesn't keep a reference to the original data" do
      data = [1, 2, 3, 4]
      memory = UrCPU::Memory.new(data)
      data << 5
      memory.should == [1, 2, 3, 4]
    end
  end
  
  describe "#start_*!" do
    before do
      @memory = UrCPU::Memory.new
    end
    
    UrCPU::Memory::SECTIONS.each do |section|
      it "start_#{section}! and #{section}_start" do
        method = "#{section}_start"
        @memory.concat [1, 2, 3, 4, 5]
        @memory.send("start_#{section}!")
        @memory.send("#{section}_start").should == 5
        @memory.concat [6, 7, 8, 9, 10]
        @memory.send("#{section}_start").should == 5
      end
    end
  end
end