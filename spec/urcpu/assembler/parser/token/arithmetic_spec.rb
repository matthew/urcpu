require File.expand_path(File.dirname(__FILE__) + "/../../../../spec_helper")

describe UrCPU::Assembler::Parser::Token::Arithmetic do
  describe "#match" do
    before do
      @token = UrCPU::Assembler::Parser::Token::Arithmetic.new(:arithmetic)
    end
    
    it "matches IMM/NUM + IMM/NUM<<NUM" do
      expected = [5 + (256 << 2)]
      @token.match("$5 + 256<<2").should == expected
      @token.match("5 + 256<<2").should == expected
      @token.match("$5 + $256<<2").should == expected
      @token.match("5 + $256<<2").should == expected
    end

    it "matches -IMM/NUM + IMM/NUM<<NUM" do
      expected = [-5 + (256 << 2)]
      @token.match("$-5 + 256<<2").should == expected
      @token.match("-5 + 256<<2").should == expected
      @token.match("$-5 + $256<<2").should == expected
      @token.match("-5 + $256<<2").should == expected
    end

    it "matches IMM/NUM + -IMM/NUM<<NUM" do
      expected = [5 + (-256 << 2)]
      @token.match("$5 + -256<<2").should == expected
      @token.match("5 + -256<<2").should == expected
      @token.match("$5 + $-256<<2").should == expected
      @token.match("5 + $-256<<2").should == expected
    end

    it "matches -IMM + -IMM/NUM<<NUM" do
      expected = [-5 + (-256 << 2)]
      @token.match("$-5 + -256<<2").should == expected
      @token.match("-5 + -256<<2").should == expected
      @token.match("$-5 + $-256<<2").should == expected
      @token.match("-5 + $-256<<2").should == expected
    end

    it "matches IMM/NUM<<SHIFT" do
      expected = [256 << 2]
      @token.match("$256<<2").should == expected
      @token.match("256<<2").should == expected
    end

    it "matches -IMM/NUM<<SHIFT" do
      expected = [-256 << 2]
      @token.match("$-256<<2").should == expected
      @token.match("-256<<2").should == expected
    end
  end
end