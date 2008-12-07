require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe UrCPU::Assembler::Parser do
  before do
    @parser = UrCPU::Assembler::Parser.new
  end
  
  describe "#parse_line" do
    def p(line)
      @parser.parse_line(line)
    end

    describe "instructions" do
      it "parses INS IMM, REG" do
        p("movl $4, %eax").should == [:movl, 4, :eax]
      end

      it "parses INS REG, REG" do
        p("movl %eax, %edx").should == [:movl, :eax, :edx]
      end

      it "parses CALL LABEL" do
        p("call ensure_string").should == [:call, :ensure_string]
      end

      it "parses PUSH REG" do
        p("push %ebx").should == [:push, :ebx]
      end

      it "parses POP REG" do
        p("pop %ecx").should == [:pop, :ecx]
      end

      it "parses INT IMM" do
        p("int $0x80").should == [:int, 0x80]
      end

      describe "memory addressing" do
        it "parses INS OFFSET(REG_BASE), REG" do
          p("lea 8(%eax), %ebx").should == [
            :lea,
            {:offset => 8, :base => :eax, :index => 0, :scale => 0},
            :ebx
          ]
        end
      
        it "parses INS REG, (BASE)" do
          p("movl %esp, (stack_bottom)").should == [
            :movl,
            :esp,
            {:offset => 0, :base => :stack_bottom, :index => 0, :scale => 0}
          ]
        end
      end

      describe "arithmetic" do
      end
    end
  
    describe "labels" do
      it "parses a label" do
        p("report_error:")
      end
    end
  
    describe "data" do
    end
  
    describe "comment" do
      it "parses a comment" do
        p("# I am a comment").should be_empty
      end
    end
  end
end
