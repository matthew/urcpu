module UrCPU
  class Assembler
    class Parser
      class AddressModeToken < Token
        def initialize(name)
          super(name, token_regex, &serializer)
        end
        
        private
        
        def token_regex
          /(\d+)?                 # optional offset
            \(
              (%?)(\w+)           # label or register
              (?:,\s*(\d+))?      # optional index
              (?:,\s*(\d+))?      # optional scale
            \)
          /x
        end
        
        def serializer
          Proc.new do |offset, reg_sigil, base, index, scale|
            is_register = !reg_sigil.empty?
            address_mode = {
              :offset => offset.to_i,
              :base => base.to_sym,
              :base_type => is_register ? :register : :label,
              :index => index.to_i,
              :scale => scale.to_i,
            }
            [address_mode]
          end
        end
      end
    end
  end
end