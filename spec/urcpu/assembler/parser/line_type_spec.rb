require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe UrCPU::Assembler::Parser::LineType do
  before do
    @parser_klass = UrCPU::Assembler::Parser
  end
  
  describe "#initialize" do
    it "raises a parse error if an unknown token is given" do
      lambda do
        @parser_klass::LineType.new(:foo, [:unknown_token])
      end.should raise_error(UrCPU::ParseError)
    end
  end
  
  describe "#match" do
    before do
      @line_type = @parser_klass::LineType.new(:ins_reg, [:ins, :space, :reg])
    end
    
    describe "successful" do
      before do
        @original_line = "mov %eax"
        @line = @original_line.clone
      end
      
      it "does not modify the line" do
        @line_type.match(@line)
        @line.should == @original_line
      end
      
      it "returns the matched content" do
        @line_type.match("mov %eax").should == [:mov, :eax]
      end
    end

    describe "unsuccessful" do
      before do
        @original_line = "mov not_a_register"
        @line = @original_line.clone
      end
      
      it "does not modify the line" do
        @line_type.match(@line)
        @line.should == @original_line
      end
      
      it "returns nil" do
        @line_type.match(@line).should be_nil
      end
      
      describe "entire line is not consumed" do
        before do
          @line = "mov %eax some extra stuff here"
        end

        it "returns nil" do
          @line_type.match(@line).should be_nil
        end
      end
      
      describe "some inner token fails but whole line consumed" do
        before do
          @tokens = [:ins, :space, :label, :space, :reg, :eol]
          @line_type = @parser_klass::LineType.new(:ins_reg, @tokens)
          @line = "jmp label"
        end

        it "returns nil" do
          @line_type.match(@line).should be_nil
        end
      end
    end
  end
end