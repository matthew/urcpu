URCPU_RAKE_ROOT_DIR = File.expand_path(File.dirname(__FILE__))

require 'rubygems' rescue nil
require 'rake'
Dir["#{URCPU_RAKE_ROOT_DIR}/rake/*.rake"].each {|file| load file}

task :default => :spec

desc 'Load UrCPU library'
task :urcpu do
  require "#{URCPU_RAKE_ROOT_DIR}/lib/urcpu"
end

desc 'Cleanup extraneous files'
task :clean