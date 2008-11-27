Gem::manage_gems

require 'rake/gempackagetask'
load "#{ROOT_DIR}/urcpu.gemspec"

Rake::GemPackageTask.new(GemSpec) do |pkg|
    pkg.need_tar = true
end

task :clean do
  system("rm", "-fr", "pkg")
end
