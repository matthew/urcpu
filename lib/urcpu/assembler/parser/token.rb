require "urcpu/assembler/parser/token/base"
require "urcpu/assembler/parser/token/immediate"
require "urcpu/assembler/parser/token/arithmetic"
require "urcpu/assembler/parser/token/address_mode"
require "urcpu/assembler/parser/token/composite"

module UrCPU
  class Assembler
    class Parser
      module Token
        class << self
          def method_missing(method, *args, &block)
            Base.send(method, *args, &block)
          end
        end
      end
    end
  end
end