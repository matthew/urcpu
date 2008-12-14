require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe UrCPU::Assembler::Parser do
  before do
    @parser = UrCPU::Assembler::Parser.new
    @ins_result_klass = UrCPU::Assembler::Parser::InstructionResult
  end
  
  describe "#parse_line" do
    def p(line)
      @parser.parse_line(line)
    end

    def ins(result)
      @ins_result_klass.new(result)
    end

    it "strips whitespace before parsing" do
      p("  movl $4, %eax   ").should == ins([:movl, 4, :eax])
    end

    describe "instructions" do
      it "parses INS IMM, REG" do
        p("movl $4, %eax").should == ins([:movl, 4, :eax])
        p("movl $foo, %eax").should == ins([:movl, :foo, :eax])
      end
      
      it "parses INS -IMM, REG" do
        p("movl $-4, %eax").should == ins([:movl, -4, :eax])
      end

      it "parses INS REG, REG" do
        p("movl %eax, %edx").should == ins([:movl, :eax, :edx])
      end

      it "parses CALL LABEL" do
        p("call ensure_string").should == ins([:call, :ensure_string])
      end

      it "parses PUSH REG" do
        p("push %ebx").should == ins([:push, :ebx])
      end

      it "parses POP REG" do
        p("pop %ecx").should == ins([:pop, :ecx])
      end

      it "parses INT IMM" do
        p("int $0x80").should == ins([:int, 0x80])
      end

      describe "memory addressing" do
        it "parses INS OFFSET(REG_BASE), REG" do
          p("lea 8(%eax), %ebx").should == ins([
            :lea,
            {
              :offset => 8, 
              :base => :eax,
              :base_type => :register,
              :index => 0,
              :index_type => :immediate,
              :scale => 0
            },
            :ebx
          ])
        end
      
        it "parses INS REG, (BASE)" do
          p("movl %esp, (stack_bottom)").should == ins([
            :movl,
            :esp,
            {
              :offset => 0,
              :base => :stack_bottom,
              :base_type => :label,
              :index => 0,
              :index_type => :immediate,
              :scale => 0
            }
          ])
        end

        it "parses INS OFFSET(BASE,LABEL), REG" do
          p("lea 8(%eax,%edx), %ebx").should == ins([
            :lea,
            {
              :offset => 8,
              :base => :eax,
              :base_type => :register,
              :index => :edx,
              :index_type => :register,
              :scale => 0
            },
            :ebx
          ])
        end
      end

      describe "arithmetic" do
        it "parses INS IMM + DIGITS<<DIGITS, REG" do
          p("movl $2 + 256<<2, %eax").should == ins([
            :movl,
            1026, # 2 + 256 << 2
            :eax
          ])
        end
      end
    end
  
    describe "labels" do
      it "parses a label" do
        @label_result_klass = UrCPU::Assembler::Parser::LabelResult
        p("report_error:").should == @label_result_klass.new([:report_error])
      end
    end
  
    describe "data" do
    end
  
    describe "comment" do
      it "parses a comment" do
        @comment_result_klass = UrCPU::Assembler::Parser::CommentResult
        p("# I am a comment").should == @comment_result_klass.new([])
      end
    end
  end
end
