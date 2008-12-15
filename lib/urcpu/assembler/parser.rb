require 'urcpu/assembler/parser/debug'
require 'urcpu/assembler/parser/token'
require 'urcpu/assembler/parser/line_type'
require 'urcpu/assembler/parser/result'

module UrCPU
  class Assembler
    class Parser
      Token.register(:ins, /(\w+)/) { |ins| ins.to_sym }
      Token.register(:space, /\s+/)
      Token.register(:comma, /,\s*/)
      Token.register(:colon, /:/)
      Token.register(:eol, /\s*$/)
      Token.register(:comment, /#.*$/)
      
      OPERANDS = [
        Token::AddressMode.register(:adr),
        Token::Arithmetic.register(:arth),
        Token.register(:reg, /%(\w+)/) { |reg| reg.to_sym },
        Token::Immediate.register(:imm),
        Token.register(:label, /(\w+)/) { |lbl| lbl.to_sym },
      ]
      Token::Composite.register(:operand, OPERANDS)
      
      LINE_TYPES = [
        LineType.new(Result::Instruction, 
          [:ins, :space, :operand, :comma, :operand, :eol]),
        LineType.new(Result::Instruction, [:ins, :space, :operand, :eol]),
        LineType.new(Result::Instruction, [:ins, :eol]),
        LineType.new(Result::Label, [:label, :colon, :eol]),
        LineType.new(Result::Comment, [:comment]),
      ]
      
      def parse_line(line)
        LINE_TYPES.each do |line_type|
          if matches = line_type.match(line.strip)
            return matches
          end
        end
        
        nil
      end
    end
  end
end