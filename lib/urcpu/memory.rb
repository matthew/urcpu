module UrCPU
  class Memory < Array
    SECTIONS = [:text, :data, :rodata, :stack]
    
    def initialize(bytes=nil)
      replace Array(bytes)
      @labels = Hash.new
      SECTIONS.each do |section|
        set_section(section)
      end
    end
    
    def set_label(label, address = length)
      raise IllegalLabel, "nil label not allowed" if label.nil?
      @labels[label] = address
    end
    
    def label(label)
      unless @labels.has_key? label
        raise IllegalLabel, "Unknown label: #{label.inspect}" 
      end
      @labels[label]
    end
    
    def set_section(section, *args)
      set_label("___#{section}___", *args)
    end

    def section(section)
      label("___#{section}___")
    end
  end
end