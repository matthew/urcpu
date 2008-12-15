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
      
      def parse_line(line)
        line_parsers.each do |line_type|
          if matches = line_type.match(line.strip)
            return matches
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
          LineParser.new(Result::Label, [:label, :colon, :eol]),
          LineParser.new(Result::Comment, [:comment]),
          LineParser.new(Result::String, [:dot, :ascii, :space, :string, :eol]),
          LineParser.new(Result::Long, [
            :dot, :long, :space, :long_value, :eol
          ]),
        ]
      end
      
      def register_tokens!
        Token.register(:ins, /(\w+)/) { |ins| ins.to_sym }
        Token.register(:reg, /%(\w+)/) { |reg| reg.to_sym }
        Token.register(:label, /(\w+)/) { |lbl| lbl.to_sym }
        Token.register(:digit, /(-?\d+)/) { |digit| digit.to_i }
        Token.register(:hexdigit, /(-?0x[\da-fA-F]+)/) { |hex| eval hex }
        Token.register(:space, /\s+/)
        Token.register(:comma, /,\s*/)
        Token.register(:colon, /:/)
        Token.register(:eol, /\s*$/)
        Token.register(:comment, /#.*$/)
        Token.register(:dot, /\./)
        Token.register(:ascii, /ascii/)
        Token.register(:long, /long/)
        
        Token::AddressMode.register(:adr)
        Token::Arithmetic.register(:arth)
        Token::Immediate.register(:imm)
        Token::String.register(:string)
        
        Token::Composite.register(:operand, [
          Token.lookup(:adr),
          Token.lookup(:arth),
          Token.lookup(:reg),
          Token.lookup(:imm),
          Token.lookup(:label)
        ])
        
        Token::Composite.register(:long_value, [
          Token.lookup(:arth),
          Token.lookup(:hexdigit),
          Token.lookup(:digit),
          Token.lookup(:label),
        ])
      end
    end
  end
end
