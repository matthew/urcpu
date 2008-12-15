require 'urcpu/assembler/parser/debug'
require 'urcpu/assembler/parser/token'
require 'urcpu/assembler/parser/line_parser'
require 'urcpu/assembler/parser/result'

module UrCPU
  class Assembler
    class Parser
      def initialize
        register_tokens!
      end
      
      def parse_file(file)
        results = Array.new
        
        File.open(file, "r").readlines.each_with_index do |line, num|
          if result = parse_line(line)
            results << result
          else
            raise UrCPU::ParseError, "Parse Error #{file}:#{num+1} #{line}"
          end
        end
        
        results
      end
      
      def parse_line(line)
        line_parsers.each do |line_type|
          if result = line_type.match(line.strip)
            return result
          end
        end
        
        nil
      end
      
      private
      
      def line_parsers
        @line_parsers ||= [
          LineParser.new(Result::Instruction, 
            [:ins, :space, :operand, :comma, :operand, :eol]),
          LineParser.new(Result::Instruction, [:ins, :space, :operand, :eol]),
          LineParser.new(Result::Instruction, [:ins, :eol]),
          LineParser.new(Result::Label, [:label, ':', :eol]),
          LineParser.new(Result::Discard, ['#', :rest_of_line]),
          LineParser.new(Result::String, ['.ascii', :space, :string, :eol]),
          LineParser.new(Result::Long, ['.long', :space, :long_value, :eol]),
          LineParser.new(Result::Align, ['.align', :space, :digit, :eol]),
          LineParser.new(Result::Section, 
            ['.section', :space, '.', :section_name, :eol]),
          LineParser.new(Result::Section, [:text, :eol]),
          LineParser.new(Result::Section, [:bss, :eol]),
          LineParser.new(Result::Section, ['.globl', :space, :label, :eol]),
          LineParser.new(Result::Discard, ['.type', :rest_of_line]),
          LineParser.new(Result::Discard, ['.size', :rest_of_line]),
          LineParser.new(Result::Discard, ['.weak', :rest_of_line]),
          LineParser.new(Result::Space, 
            ['.space', :space, :space_value, :eol]),
        ]
      end
      
      def register_tokens!
        Token.register(:ins, /(\w+)/) { |ins| ins.to_sym }
        Token.register(:reg, /%(\w+)/) { |reg| reg.to_sym }
        Token.register(:absolute, /\*%(\w+)/) { |reg| reg.to_sym }
        Token.register(:label, /(\w+)/) { |lbl| lbl.to_sym }
        Token.register(:digit, /(-?\d+)/) { |digit| digit.to_i }
        Token.register(:hexdigit, /(-?0x[\da-fA-F]+)/) { |hex| eval hex }
        Token.register(:section_name, /(rodata|bss|data)/) { |sec| sec.to_sym }
        Token.register(:space, /\s+/)
        Token.register(:comma, /,\s*/)
        Token.register(:eol, /\s*$/)
        Token.register(:rest_of_line, /.*$/)
        Token.register(:text, /\.text/) { :text }
        Token.register(:bss, /\.bss/) { :bss }
        
        Token::AddressMode.register(:adr)
        Token::Arithmetic.register(:arth)
        Token::Immediate.register(:imm)
        Token::String.register(:string)
        
        Token::Composite.register(:operand, [
          Token.lookup(:adr),
          Token.lookup(:arth),
          Token.lookup(:reg),
          Token.lookup(:absolute),
          Token.lookup(:imm),
          Token.lookup(:label)
        ])
        
        Token::Composite.register(:long_value, [
          Token.lookup(:arth),
          Token.lookup(:hexdigit),
          Token.lookup(:digit),
          Token.lookup(:label),
        ])

        Token::Composite.register(:space_value, [
          Token.lookup(:arth),
          Token.lookup(:digit)
        ])
      end
    end
  end
end
