require File.expand_path(File.dirname(__FILE__) + "/../../../../spec_helper")

describe UrCPU::Assembler::Parser::Token::Base do
  describe "class methods" do
    describe "#register" do
      it "can register something and look it up" do
        UrCPU::Assembler::Parser::Token::Base.register(:foo, /foo/)
        token = UrCPU::Assembler::Parser::Token.lookup(:foo)
        token.name.should == :foo
        token.should be_kind_of(UrCPU::Assembler::Parser::Token::Base)
      end
    end
  end
  
  describe "#match" do
    before do
      @name = :tok
      @regex = /foo_(\d+)_bar/
      @token = UrCPU::Assembler::Parser::Token::Base.new(@name, @regex) do |digit|
        2 * digit.to_i
      end
    end
    
    describe "successful" do
      before do
        @line = "foo_97_bar"
      end
      
      it "consumes the line" do
        @token.match(@line)
        @line.should be_empty
      end
      
      it "post-processes the captures" do
        @token.match(@line).should == [ 97 * 2 ]
      end
      
      describe "no conversion block given" do
        before do
          @token = UrCPU::Assembler::Parser::Token::Base.new(@name, @regex)
        end
        
        it "consumes the line" do
          @token.match(@line)
          @line.should be_empty
        end
        
        it "returns the empty list even though there are captures" do
          @token.match(@line).should be_empty
        end
      end
    end

    describe "unsuccessful" do
      before do
        @original_line = "some line that will not match"
        @line = @original_line.clone
      end
      
      it "does not consume the line" do
        @token.match(@line)
        @line.should == @original_line
      end
      
      it "returns nil" do
        @token.match(@line).should be_nil
      end
      
      describe "token not at start" do
        before do
          @original_line = "some crap foo_97_bar"
          @line = @original_line.clone
        end
        
        it "does not consume the line" do
          @token.match(@line)
          @line.should == @original_line
        end

        it "returns nil" do
          @token.match(@line).should be_nil
        end
      end
    end
  end
end