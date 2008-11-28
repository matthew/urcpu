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
    
    def [](address, count = nil)
      unless in_bounds?(address, count.to_i)
        raise MemoryOutOfRange, "Address #{address} is out of range."
      end
      count.nil? ? super(address) : super(address, count)
    end
    
    def set_label(label, address = length)
      unless label.to_s =~ (regex = /^\w+$/)
        raise IllegalLabel, "Label #{label.inspect} must match #{regex}"
      end
      @labels[label.to_s] = address
    end
    
    def label(label)
      unless @labels.has_key? label.to_s
        raise IllegalLabel, "Unknown label: #{label.inspect}" 
      end
      @labels[label.to_s]
    end
    
    def set_section(section, *args)
      set_label("___#{section}___", *args)
    end

    def section(section)
      label("___#{section}___")
    end
    
    private 

    def in_bounds?(address, count)
      range = Range.new(0, length, :do_not_include_end_point)
      range.include?(address) && (
        (count == 0) || (
          (count > 0) &&
          range.include?(address + count - 1)
        )
      )
    end
  end
end