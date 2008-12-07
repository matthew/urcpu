require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe UrCPU::Assembler::Parser::CompositeToken do
  before do
    @foo_token = UrCPU::Assembler::Parser::Token.new(:foo, /foo/) { "foo" }
    @bar_token = UrCPU::Assembler::Parser::Token.new(:bar, /bar/) { "bar" }
    @token = UrCPU::Assembler::Parser::CompositeToken.new(
      :foo_and_bar,
      [@foo_token, @bar_token]
    )
  end
  
  describe "#match" do
    describe "successful" do
      it "matches foo and bar" do
        @token.match("foo").should == ["foo"]
        @token.match("bar").should == ["bar"]
      end
    
      describe "ordering" do
        it "will not invoke bar if foo matches" do
          dont_allow(@bar_token).match(line = "foo")
          @token.match(line)
        end

        it "will try foo even if bar matches" do
          mock.proxy(@foo_token).match(line = "bar")
          @token.match(line)
        end
      end
    end
    
    describe "unsuccessful" do
      it "will return nil if none of the tokens match" do
        @token.match("i will not match").should be_nil
      end
    end
  end
end