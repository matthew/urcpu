require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe UrCPU::Assembler::Parser::AddressModeToken do
  before do
    @token = UrCPU::Assembler::Parser::AddressModeToken.new(:adr)
    @default = { :offset => 0, :index => 0, :scale => 0 }
    @reg = :eax
    @label = :main
  end
  
  def reg_expected(overrides = {})
    [@default.merge(:base => @reg, :base_type => :register).merge(overrides)]
  end

  def label_expected(overrides = {})
    [@default.merge(:base => @label, :base_type => :label).merge(overrides)]
  end

  it "matches (base)" do
    @token.match("(%#{@reg})").should == reg_expected
    @token.match("(#{@label})").should == label_expected
  end
  
  it "matches (base, index)" do
    @token.match("(%#{@reg}, 5)").should == reg_expected(:index => 5)
    @token.match("(#{@label}, 5)").should == label_expected(:index => 5)
  end
  
  it "matches (base, index, scale)" do
    @token.match("(%#{@reg}, 5, 8)").should == reg_expected(:index => 5, :scale => 8)
    @token.match("(#{@label}, 5, 8)").should == label_expected(:index => 5, :scale => 8)
  end
  
  it "matches offset(base)" do
    @token.match("100(%#{@reg})").should == reg_expected(:offset => 100)
    @token.match("100(#{@label})").should == label_expected(:offset => 100)
  end
  
  it "matches offset(base, index)" do
    @token.match("100(%#{@reg}, 5)").should == reg_expected(:offset => 100, :index => 5)
    @token.match("100(#{@label}, 5)").should == label_expected(:offset => 100, :index => 5)
  end
  
  it "matches offset(base, index, scale)" do
    @token.match("100(%#{@reg}, 5, 8)").should == reg_expected(:offset => 100, :index => 5, :scale => 8)
    @token.match("100(#{@label}, 5, 8)").should == label_expected(:offset => 100, :index => 5, :scale => 8)
  end
  
  describe "spacing" do
    it "it does not care about inner spacing" do
      expectation = reg_expected(:offset => 100, :index => 5, :scale => 8)
      @token.match("100(%#{@reg}, 5, 8)").should == expectation
      @token.match("100(%#{@reg},5, 8)").should == expectation
      @token.match("100(%#{@reg}, 5,8)").should == expectation
      @token.match("100(%#{@reg},5,8)").should == expectation
    end
  end
end