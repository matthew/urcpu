URCPU_ROOT = File.expand_path(File.dirname(__FILE__))
$: << URCPU_ROOT

require 'urcpu/exceptions'

require 'urcpu/slots'
require 'urcpu/flags'
require 'urcpu/registers'

require 'urcpu/memory'
require 'urcpu/os'
require 'urcpu/instructions'
require 'urcpu/core'

require 'urcpu/assembler'