URCPU_ROOT = File.expand_path(File.dirname(__FILE__))
$: << URCPU_ROOT

require 'urcpu/exceptions.rb'

require 'urcpu/slots.rb'
require 'urcpu/flags.rb'
require 'urcpu/registers.rb'

require 'urcpu/instructions.rb'

require 'urcpu/memory.rb'
require 'urcpu/os.rb'
require 'urcpu/core.rb'
