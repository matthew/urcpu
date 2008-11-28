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
  
  describe "memory bounds" do
    before do
      @max = 10
      @memory = UrCPU::Memory.new(1 .. @max)
    end
    
    it "#[] does not throw exception if memory address is in range" do
      lambda { @memory[0] }.should_not raise_error(UrCPU::MemoryOutOfRange)
      lambda { @memory[@max - 1] }.should_not raise_error(UrCPU::MemoryOutOfRange)
    end
    
    it "#[] does not throw exception if memory range is entirely in memory" do
      lambda { @memory[0, 0] }.should_not raise_error(UrCPU::MemoryOutOfRange)
      lambda { @memory[0, 1] }.should_not raise_error(UrCPU::MemoryOutOfRange)
      lambda { @memory[0, @memory.length] }.should_not raise_error(UrCPU::MemoryOutOfRange)
      lambda { @memory[@max - 1, 0] }.should_not raise_error(UrCPU::MemoryOutOfRange)
      lambda { @memory[@max - 1, 1] }.should_not raise_error(UrCPU::MemoryOutOfRange)
    end
    
    it "#[] throws exception if memory address is less than zero" do
      lambda { @memory[-1] }.should raise_error(UrCPU::MemoryOutOfRange)
    end
    
    it "#[] throws exception if memory address is beyond end of memory" do
      lambda { @memory[@max] }.should raise_error(UrCPU::MemoryOutOfRange)
      lambda { @memory[@max + 1] }.should raise_error(UrCPU::MemoryOutOfRange)
    end

    it "#[] throws exception if memory range is beyond end of memory" do
      lambda { @memory[2, -1] }.should raise_error(UrCPU::MemoryOutOfRange)
      lambda { @memory[@max - 1, 2] }.should raise_error(UrCPU::MemoryOutOfRange)
    end

    it "#[]= never throws an exception" do
      max = 10
      memory = UrCPU::Memory.new(1 .. max)
      lambda do
        memory[-1] = 2
        memory[max] = 3
        memory[max + 1] = 5
        memory[0] = 7
        memory[max - 1]  = 11
      end.should_not raise_error(UrCPU::MemoryOutOfRange)
    end
  end
  
  describe "labels" do
    before do
      @memory = UrCPU::Memory.new([1, 2, 3, 4])
    end
    
    it "the label is assigned the current memory address" do
      @memory.set_label("foo")
      @memory.label("foo").should == @memory.length
    end

    it "the label is assigned the given memory address" do
      @memory.set_label("foo", 3)
      @memory.label("foo").should == 3
      @memory.label(:foo).should == 3
      
      @memory.set_label(:bar, 7)
      @memory.label("bar").should == 7
      @memory.label(:bar).should == 7
    end
    
    it "should raise an exception if an unknown label is given" do
      lambda { @memory.label("foo") }.should raise_error(UrCPU::IllegalLabel)
    end
    
    it "should raise an exception if the label name doesn't match \\w+" do
      lambda { @memory.set_label(nil) }.should raise_error(UrCPU::IllegalLabel)
      lambda { @memory.set_label("") }.should raise_error(UrCPU::IllegalLabel)
      lambda { @memory.set_label(" ") }.should raise_error(UrCPU::IllegalLabel)
      lambda { 
        @memory.set_label(" *$%^\#{$%} ") 
      }.should raise_error(UrCPU::IllegalLabel)
    end
  
    describe "#section" do
      it "a section is just a special label" do
        mock(@memory).set_label("___text___", 5)
        @memory.set_section("text", 5)

        mock(@memory).label("___text___")
        @memory.section("text")
      end
      
      it "allows for accessing labels right away" do
        UrCPU::Memory::SECTIONS.each do |section|
          @memory.section(section).should == @memory.length
        end
      end
    end
  end
end