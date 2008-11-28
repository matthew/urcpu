module UrCPU
  class BusError < StandardError; end
  class UnknownSystemCall < StandardError; end
  class IllegalLabel < StandardError; end
end