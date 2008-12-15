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
          def register(*args, &block)
            Base.register(*args, &block)
          end
          
          def lookup(name)
            if token = registry[name]
              token
            else
              raise UrCPU::ParseError, "Unknown token: #{name.inspect}"
            end
          end
          
          def save(token)
            registry[token.name] = token
          end
          
          private
          
          def registry
            @registry ||= Hash.new
          end
        end
      end
    end
  end
end