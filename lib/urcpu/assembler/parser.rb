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
        ]
      end
      
      def register_tokens!
        Token.register(:ins, /(\w+)/) { |ins| ins.to_sym }
        Token.register(:space, /\s+/)
        Token.register(:comma, /,\s*/)
        Token.register(:colon, /:/)
        Token.register(:eol, /\s*$/)
        Token.register(:comment, /#.*$/)
        Token.register(:dot, /\./)
        Token.register(:ascii, /ascii/)
        Token::String.register(:string)
        Token::Composite.register(:operand, operands)
      end
      
      def operands
        @operands ||= [
          Token::AddressMode.register(:adr),
          Token::Arithmetic.register(:arth),
          Token.register(:reg, /%(\w+)/) { |reg| reg.to_sym },
          Token::Immediate.register(:imm),
          Token.register(:label, /(\w+)/) { |lbl| lbl.to_sym },
        ]
      end
    end
  end
end
