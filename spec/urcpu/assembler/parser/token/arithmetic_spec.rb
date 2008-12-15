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

    it "matches IMM/NUM * IMM/NUM<<NUM" do
      expected = [5 * (256 << 2)]
      @token.match("$5 * 256<<2").should == expected
      @token.match("5 * 256<<2").should == expected
      @token.match("$5 * $256<<2").should == expected
      @token.match("5 * $256<<2").should == expected
    end

    it "matches -IMM/NUM * IMM/NUM<<NUM" do
      expected = [-5 * (256 << 2)]
      @token.match("$-5 * 256<<2").should == expected
      @token.match("-5 * 256<<2").should == expected
      @token.match("$-5 * $256<<2").should == expected
      @token.match("-5 * $256<<2").should == expected
    end

    it "matches IMM/NUM * -IMM/NUM<<NUM" do
      expected = [5 * (-256 << 2)]
      @token.match("$5 * -256<<2").should == expected
      @token.match("5 * -256<<2").should == expected
      @token.match("$5 * $-256<<2").should == expected
      @token.match("5 * $-256<<2").should == expected
    end

    it "matches -IMM * -IMM/NUM<<NUM" do
      expected = [-5 * (-256 << 2)]
      @token.match("$-5 * -256<<2").should == expected
      @token.match("-5 * -256<<2").should == expected
      @token.match("$-5 * $-256<<2").should == expected
      @token.match("-5 * $-256<<2").should == expected
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

    it "matches IMM/NUM * IMM/NUM" do
      expected = [97*42]
      @token.match("$97*$42").should == expected
      @token.match("97*42").should == expected
      @token.match("$97*42").should == expected
      @token.match("97*$42").should == expected
      @token.match("$97 * $42").should == expected
      @token.match("97 * 42").should == expected
      @token.match("$97 * 42").should == expected
      @token.match("97 * $42").should == expected
    end
    
    it "matches -IMM/NUM * IMM/NUM" do
      expected = [-97*42]
      @token.match("$-97*$42").should == expected
      @token.match("-97*42").should == expected
      @token.match("$-97*42").should == expected
      @token.match("-97*$42").should == expected
      @token.match("$-97 * $42").should == expected
      @token.match("-97 * 42").should == expected
      @token.match("$-97 * 42").should == expected
      @token.match("-97 * $42").should == expected
    end

    it "matches IMM/NUM * -IMM/NUM" do
      expected = [97*-42]
      @token.match("$97*$-42").should == expected
      @token.match("97*-42").should == expected
      @token.match("$97*-42").should == expected
      @token.match("97*$-42").should == expected
      @token.match("$97 * $-42").should == expected
      @token.match("97 * -42").should == expected
      @token.match("$97 * -42").should == expected
      @token.match("97 * $-42").should == expected
    end

    it "matches -IMM/NUM * -IMM/NUM" do
      expected = [-97*-42]
      @token.match("$-97*$-42").should == expected
      @token.match("-97*-42").should == expected
      @token.match("$-97*-42").should == expected
      @token.match("-97*$-42").should == expected
      @token.match("$-97 * $-42").should == expected
      @token.match("-97 * -42").should == expected
      @token.match("$-97 * -42").should == expected
      @token.match("-97 * $-42").should == expected
    end
    
    it "should match a positive base 10 number" do
      @token.match("$0").should == [0]
      @token.match("$100").should == [100]
      @token.match("$99999999999999999999").should == [99999999999999999999]
    end

    it "should match a negative base 10 number" do
      @token.match("$-0").should == [0]
      @token.match("$-100").should == [-100]
      @token.match("$-99999999999999999999").should == [-99999999999999999999]
    end

    it "should match a positive base 16 number" do
      # @token.match("$0x0").should == [0]
      @token.match("$0xA").should == [0xA]
      @token.match("$0x9").should == [0x9]
      @token.match("$0x97").should == [0x97]
      @token.match("$0xFA").should == [0xFA]
      @token.match("$0x9A").should == [0x9A]
      @token.match("$0xcD").should == [0xcD]
      @token.match("$0xab").should == [0xab]
      @token.match("$0xFFFFFFFFFFFFFFFFFF").should == [0xFFFFFFFFFFFFFFFFFF]
    end

    it "should match a negative base 16 number" do
      @token.match("$-0x0").should == [0]
      @token.match("$-0xA").should == [-0xA]
      @token.match("$-0x9").should == [-0x9]
      @token.match("$-0x97").should == [-0x97]
      @token.match("$-0xFA").should == [-0xFA]
      @token.match("$-0x9A").should == [-0x9A]
      @token.match("$-0xcD").should == [-0xcD]
      @token.match("$-0xab").should == [-0xab]
      @token.match("$-0xFFFFFFFFFFFFFFFFF").should == [-0xFFFFFFFFFFFFFFFFF]
    end
  end
end