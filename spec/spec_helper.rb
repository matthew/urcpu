require 'rubygems' rescue nil
require 'spec'

SPEC_DIR = File.dirname(__FILE__)

require File.expand_path("#{SPEC_DIR}/../lib/urcpu")
Dir["#{SPEC_DIR}/helpers/**/*.rb"].each do |file|
  require file
end

Spec::Runner.configure do |config|
  config.mock_with :rr
end
