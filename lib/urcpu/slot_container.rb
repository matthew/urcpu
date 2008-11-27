module UrCPU
  class SlotContainer
    def self.slots
      []
    end
    
    def initialize(default)
      @default = default
      reset!
    end
    
    def [](slot)
      assert_valid_slot(slot)
      instance_variable_get("@#{slot}")
    end
    
    def []=(slot, value)
      assert_valid_slot(slot)
      instance_variable_set("@#{slot}", value)
    end
    
    def reset!
      self.class.slots.each do |slot|
        self[slot] = @default
      end
    end
    
    def to_s
      "<" + self.class.slots.map do |slot|
        "#{slot}:#{self[slot]}"
      end.join(" ") + ">"
    end
    alias :inspect :to_s
    
    private
    
    def valid_slot?(slot)
      self.class.slots.include? slot
    end

    def assert_valid_slot(slot)
      unless valid_slot? slot
        raise ArgumentError, "Unknown slot #{slot.inspect}" 
      end
    end
  end
end
