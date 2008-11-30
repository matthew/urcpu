URCPU_RAKE_ROOT_DIR = File.expand_path(File.dirname(__FILE__))

require 'rubygems' rescue nil
require 'rake'
Dir["#{URCPU_RAKE_ROOT_DIR}/rake/*.rake"].each {|file| load file}

task :default => :spec

desc 'Cleanup extraneous files'
task :clean