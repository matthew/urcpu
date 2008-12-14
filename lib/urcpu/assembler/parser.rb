require 'urcpu/assembler/parser/debug'

require 'urcpu/assembler/parser/token'
require 'urcpu/assembler/parser/immediate_token'
require 'urcpu/assembler/parser/address_mode_token'
require 'urcpu/assembler/parser/arithmetic_token'
require 'urcpu/assembler/parser/composite_token'

require 'urcpu/assembler/parser/line_type'

require 'urcpu/assembler/parser/comment_result'
require 'urcpu/assembler/parser/instruction_result'
require 'urcpu/assembler/parser/label_result'

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
        AddressModeToken.register(:adr),
        ArithmeticToken.register(:arth),
        Token.register(:reg, /%(\w+)/) { |reg| reg.to_sym },
        ImmediateToken.register(:imm),
        Token.register(:label, /(\w+)/) { |lbl| lbl.to_sym },
      ]
      CompositeToken.register(:operand, OPERANDS)
      
      LINE_TYPES = [
        LineType.new(InstructionResult, 
          [:ins, :space, :operand, :comma, :operand, :eol]),
        LineType.new(InstructionResult, [:ins, :space, :operand, :eol]),
        LineType.new(InstructionResult, [:ins, :eol]),
        LineType.new(LabelResult, [:label, :colon, :eol]),
        LineType.new(CommentResult, [:comment]),
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