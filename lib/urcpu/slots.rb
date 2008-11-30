module UrCPU
  class Slots
    def initialize(default)
      @default = default
      @state = Hash.new
      reset!
    end
    
    def [](slot)
      assert_valid_slot(slot)
      @state[slot]
    end
    
    def []=(slot, value)
      assert_valid_slot(slot)
      @state[slot] = value
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
