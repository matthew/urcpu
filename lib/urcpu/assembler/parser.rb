require 'urcpu/assembler/parser/token'
require 'urcpu/assembler/parser/address_mode_token'
require 'urcpu/assembler/parser/arithmetic_token'
require 'urcpu/assembler/parser/composite_token'
require 'urcpu/assembler/parser/line_type'

module UrCPU
  class Assembler
    class Parser
      OPERANDS = [
        AddressModeToken.register(:adr),
        ArithmeticToken.register(:arth),
        Token.register(:reg, /%(\w+)/) { |reg| reg.to_sym },
        Token.register(:imm, /\$(-?\d+(?:x\d+)?)/) { |imm| eval imm },        
        Token.register(:label, /(\w+)/) { |lbl| lbl.to_sym },
      ]
      
      TOKENS = [
        Token.register(:ins, /(\w+)/) { |ins| ins.to_sym },
        Token.register(:space, /\s+/),
        Token.register(:comma, /,\s*/),
        Token.register(:eol, /\s*$/),
        Token.register(:comment, /#.*$/),
        CompositeToken.register(:operand, OPERANDS)
      ]
      
      LINE_TYPES = [
        LineType.new(:ins2, [:ins, :space, :operand, :comma, :operand, :eol]),
        LineType.new(:ins1, [:ins, :space, :operand, :eol]),
        LineType.new(:ins0, [:ins, :eol]),
        LineType.new(:comment, [:comment]),
      ]
      
      def parse_line(line)
        LINE_TYPES.each do |line_type|
          debug "TRYING LineType #{line_type.type}"
          if matches = line_type.match(line)
            return matches
          end
          debug
        end
        
        nil
      end
      
      private
      
      def debug(str = "")
        puts str if $URCPU_DEBUG
      end
    end
  end
end