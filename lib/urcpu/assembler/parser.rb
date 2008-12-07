require 'urcpu/assembler/parser/token'
require 'urcpu/assembler/parser/line_type'

module UrCPU
  class Assembler
    class Parser
      TOKENS = [
        Token.new(:ins, /(\w+)/) { |ins| ins.to_sym },
        Token.new(:reg, /%(\w+)/) { |reg| reg.to_sym },
        Token.new(:imm, /\$(\d+(?:x\d+)?)/) { |imm| eval imm },
        
        # (base)
        # (base, index)
        # (base, index, scale)
        # offset(base)
        # offset(base, index)
        # offset(base, index, scale)
        Token.new(:adr, /(\d+)?\(%?(\w+)(?:,\s*(\d+)){0,2}\)/) { |offset, base, index, scale|
          [{:offset => offset.to_i,
            :base => base.to_sym,
            :index => index.to_i,
            :scale => scale.to_i,
          }]
        },
        
        Token.new(:label, /(\w+)/) { |lbl| lbl.to_sym },
        Token.new(:space, /\s+/),
        Token.new(:comma, /,\s*/),
        Token.new(:eol, /\s*$/),
        Token.new(:comment, /#.*$/),
      ]
      
      LINE_TYPES = [
        LineType.new(:ins_imm_reg, [:ins, :space, :imm, :comma, :reg, :eol]),
        LineType.new(:ins_reg_reg, [:ins, :space, :reg, :comma, :reg, :eol]),
        LineType.new(:ins_label, [:ins, :space, :label, :eol]),
        LineType.new(:ins_reg, [:ins, :space, :reg, :eol]),
        LineType.new(:ins_imm, [:ins, :space, :imm, :eol]),
        LineType.new(:ins_adr_reg, [:ins, :space, :adr, :comma, :reg, :eol]),
        LineType.new(:ins_reg_adr, [:ins, :space, :reg, :comma, :adr, :eol]),
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