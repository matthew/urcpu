require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe UrCPU::Assembler::Parser do
  before do
    @parser = UrCPU::Assembler::Parser.new
    @ins_result_klass = UrCPU::Assembler::Parser::Result::Instruction
  end
  
  describe "#parse_file" do
    before do
      @expected_lines = [
        "start:             \n",
        "   mov 5, %eax     \n",
        "   mov 7, %ebx     \n",
        "   add %eax, %ebx  \n"
      ]

      mock(File).open(@file = "some_file", "r").stub!.readlines do
        @expected_lines
      end
    end
    
    it "parses a file a line at a time and calles parse_line on them" do
      results = [:x, :y, :z, :w]
      @expected_lines.each do |line|
        mock(@parser).parse_line(line) { results.shift }
      end
      
      @parser.parse_file(@file).should == [:x, :y, :z, :w]
    end
    
    it "rasies a parse error if some line can not be parsed" do
      mock(@parser).parse_line(@expected_lines[0]) { :x }
      mock(@parser).parse_line(@expected_lines[1]) { :y }
      mock(@parser).parse_line(@expected_lines[2]) { nil }
      lambda do 
        @parser.parse_file(@file) 
      end.should raise_error(UrCPU::ParseError)
    end
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
      
      describe ".space" do
        before do
          @space_result = UrCPU::Assembler::Parser::Result::Space
        end
        
        it "parses .space SIZE" do
          p('.space 1024').should == @space_result.new([1024])
        end

        it "parses .space EXPR" do
          p('.space 97*42').should == @space_result.new([97*42])
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

        describe ".bss" do
          it "parses correctly" do
            p('.bss').should == @section_result.new([:bss])
          end
        end
        
        describe ".globl" do
          it "discards these types" do
            p('.globl _start').should == @section_result.new([:_start])
          end
        end

        describe "ignored directives" do
          before do
            @discard_result = UrCPU::Assembler::Parser::Result::Discard
          end

          describe ".type" do
            it "discards these types" do
              p('.type _foobar, @function').should == @discard_result.new([""])
            end
          end

          describe ".size" do
            it "discards these lines" do
              p('.size _foobar, .-_foobar').should == @discard_result.new([""])
            end
          end
          
          describe ".weak" do
            it "discards these lines" do
              p('.weak _start').should == @discard_result.new([""])
            end
          end
        end
      end
    end
  
    describe "comment" do
      it "parses a comment" do
        @discard_result = UrCPU::Assembler::Parser::Result::Discard
        p("# I am a comment").should == @discard_result.new([])
      end
    end
  end
end
