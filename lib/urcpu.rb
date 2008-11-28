ROOT_DIR = File.expand_path(File.dirname(__FILE__))
$: << ROOT_DIR

require 'urcpu/exceptions.rb'

require 'urcpu/slots.rb'
require 'urcpu/flags.rb'
require 'urcpu/registers.rb'

require 'urcpu/memory.rb'
require 'urcpu/os.rb'
require 'urcpu/core.rb'
