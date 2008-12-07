module UrCPU
  class Error < StandardError; end
  class BusError < Error; end
  class UnknownSystemCall < Error; end
  class IllegalLabel < Error; end
  class IllegalInstruction < Error; end
  class MemoryOutOfRange < Error; end
  class ParseError < Error; end
end