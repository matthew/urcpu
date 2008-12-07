module UrCPU
  class Assembler
    class Parser
      class AddressModeToken < Token
        def initialize(name)
          super(name, token_regex, &serializer)
        end
        
        private
        
        def token_regex
          /(-?\d+)?        # optional offset, possibly negative
            \(             
              (%?)(\w+)    # label or register
              (?:          # optional index
                ,\s*          # comma seperator
                (?:        
                  %(\w+) |    # index could be register
                  (\d+)       # index could be just numbers
                )          
              )?           
              (?:          # optional scale
                ,\s*          # comma seperator
                (\d+)         # scale is always numbers
              )?
            \)
          /x
        end
        
        def serializer
          Proc.new do |offset, reg_sigil, base, index_reg, index_imm, scale|
            base_is_register = !reg_sigil.empty?
            index_is_register = !index_reg.nil?
            address_mode = {
              :offset => offset.to_i,
              :base => base.to_sym,
              :base_type => base_is_register ? :register : :label,
              :index => index_is_register ? index_reg.to_sym : index_imm.to_i,
              :index_type => index_is_register ? :register : :immediate,
              :scale => scale.to_i,
            }
            [address_mode]
          end
        end
      end
    end
  end
end