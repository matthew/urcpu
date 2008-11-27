require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe UrCPU::Flags do
  before do
    @flags = UrCPU::Flags.new
  end
  
  describe "flag access by [] and method" do
    UrCPU::Flags::FLAGS.each do |flag|
      it "#[#{flag}] #[#{flag}]=" do
        @flags[flag].should be_false
        @flags[flag] = true
        @flags[flag].should be_true
      end
    end
  end
end