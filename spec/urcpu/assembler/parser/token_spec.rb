require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe UrCPU::Assembler::Parser::Token do
  describe "module methods" do
    describe "#register and #lookup" do
      it "can register something and look it up" do
        UrCPU::Assembler::Parser::Token.register(:foo, /foo/)
        token = UrCPU::Assembler::Parser::Token.lookup(:foo)
        token.name.should == :foo
        token.should be_kind_of(UrCPU::Assembler::Parser::Token::Base)
      end
      
      it "looking up an unknown token raises an error" do
        lambda do
          UrCPU::Assembler::Parser::Token.lookup(:unknown)
        end.should raise_error(UrCPU::ParseError)
      end
    end
    
    describe "#save and #lookup" do
      it "can register something and look it up" do
        foo = mock!.name { :foo }.subject
        UrCPU::Assembler::Parser::Token.save(foo)
        token = UrCPU::Assembler::Parser::Token.lookup(:foo)
        token.should be_eql(foo)
      end
    end
  end
end