module UrCPU
  class Assembler
    class Parser
      module Debug
        private
        
        def debug(str = "")
          puts str if $URCPU_DEBUG
        end
      end
    end
  end
end