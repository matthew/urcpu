module UrCPU
  class Memory < Array
    SECTIONS = [:text, :data, :rodata, :stack]
    
    def initialize(bytes=nil)
      replace Array(bytes)
    end
    
    SECTIONS.each do |section|
      class_eval <<-CODE
        def #{section}_start
          @#{section}_start ||= 0
        end
        
        def start_#{section}!
          @#{section}_start = length
        end
      CODE
    end
  end
end