require File.expand_path(File.dirname(__FILE__) + "/../../../../spec_helper")

describe UrCPU::Assembler::Parser::Token::Immediate do
  describe "#match" do
    before do
      @token = UrCPU::Assembler::Parser::Token::Immediate.new(:imm)
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

    it "should match a bitwise negated number" do
      @token.match("$~0").should == [~0]
      @token.match("$~2").should == [~2]
      @token.match("$~99999999999999999999").should == [~99999999999999999999]
    end

    it "should match a positive base 16 number" do
      @token.match("$0x0").should == [0]
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

    it "should match a label" do
      @token.match("$label").should == [:label]
      @token.match("$i_am_a_label").should == [:i_am_a_label]
      @token.match("$______").should == [:______]
    end

    it "should match illegal numbers as labels" do
      @token.match("$97x97").should == [:"97x97"]
      @token.match("$0xZZZ").should == [:"0xZZZ"]
      @token.match("$5555X").should == [:"5555X"]
    end

    it "should not match a 'negative' label" do
      @token.match("$-foo").should be_nil
    end
    
    it "should match a character" do
      %w{A B C X Y Z a b c x y z}.each do |char|
        ascii_code = "#{char}"[0]
        @token.match("$'#{char}").should == [ascii_code]
      end
    end
  end
end