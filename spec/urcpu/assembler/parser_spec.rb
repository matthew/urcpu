require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe UrCPU::Assembler::Parser do
  before do
    @parser = UrCPU::Assembler::Parser.new
    @ins_result_klass = UrCPU::Assembler::Parser::Result::Instruction
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

      it "parses CALL ABSOLUTE" do
        p("call *%eax").should == ins([:call, :eax])
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
        @label_result_klass = UrCPU::Assembler::Parser::Result::Label
        p("report_error:").should == @label_result_klass.new([:report_error])
      end
    end
  
    describe "data" do
      describe ".ascii" do
        before do
          @string_result = UrCPU::Assembler::Parser::Result::String
        end
        
        it "can parse a basic string" do
          p('.ascii "cows are good"').should == \
            @string_result.new(["cows are good"])
        end

        it "can parse a string with escaped quotes" do
          p('.ascii "I \"like\" cows"').should == \
            @string_result.new(['I "like" cows'])
        end
      end
      
      describe ".long" do
        before do
          @long_result = UrCPU::Assembler::Parser::Result::Long
        end
        
        it "can parse a .long with an integer" do
          p('.long 97').should == @long_result.new([97])
          p('.long -97').should == @long_result.new([-97])
        end

        it "can parse a .long with a hexidecimal number" do
          p('.long 0xFA').should == @long_result.new([0xFA])
          p('.long 0xcb').should == @long_result.new([0xcb])
          p('.long 0xaF').should == @long_result.new([0xaF])
          p('.long 0x97').should == @long_result.new([0x97])
          p('.long 0x7F').should == @long_result.new([0x7F])
          p('.long -0x97').should == @long_result.new([-0x97])
          p('.long 0x123456789ABCDEF').should == @long_result.new([0x123456789ABCDEF])
        end
        
        it "can parse a .long with a label" do
          p('.long _cows').should == @long_result.new([:_cows])
          p('.long some_label').should == @long_result.new([:some_label])
          p('.long _________').should == @long_result.new([:_________])
        end

        it "can parse a .long with an arithmetic expression" do
          p('.long 2 + 113<<2').should == @long_result.new([2 + (113<<2)])
        end
      end
      
      describe ".align" do
        before do
          @align_result = UrCPU::Assembler::Parser::Result::Align
        end
        
        it "parses .align INT" do
          p('.align 4').should == @align_result.new([4])
        end
      end

      describe ".section" do
        before do
          @section_result = UrCPU::Assembler::Parser::Result::Section
        end
        
        it "parses correctly" do
          p('.section .data').should == @section_result.new([:data])
          p('.section .bss').should == @section_result.new([:bss])
          p('.section .rodata').should == @section_result.new([:rodata])
          p('.section .rodata  ').should == @section_result.new([:rodata])
        end
        
        describe ".text" do
          it "parses correctly" do
            p('.text').should == @section_result.new([:text])
          end
        end

        describe ".type" do
          before do
            @comment_result = UrCPU::Assembler::Parser::Result::Discard
          end
          
          it "discards these types" do
            p('.type _foobar, @function').should == @comment_result.new([""])
          end
        end

        describe ".size" do
          before do
            @comment_result = UrCPU::Assembler::Parser::Result::Discard
          end
          
          it "discards these types" do
            p('.size _foobar, .-_foobar').should == @comment_result.new([""])
          end
        end
      end
    end
  
    describe "comment" do
      it "parses a comment" do
        @comment_result_klass = UrCPU::Assembler::Parser::Result::Discard
        p("# I am a comment").should == @comment_result_klass.new([])
      end
    end
  end
end
