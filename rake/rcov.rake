namespace :spec do
  desc 'Measures test coverage'
  task :rcov  => [:clean] do
    opts = File.open("#{URCPU_RAKE_ROOT_DIR}/spec/rcov.opts").readlines.map {|l| l.strip}
    rcov = "rcov #{opts.join(' ')}"
    specs = Dir["#{URCPU_RAKE_ROOT_DIR}/spec/**/*_spec.rb"].to_a
    system("#{rcov} #{specs.join(' ')}")
    system("open coverage/index.html") if RUBY_PLATFORM =~ /darwin/i
  end
end

task :clean do
  system("rm", "-fr", "#{URCPU_RAKE_ROOT_DIR}/coverage", "#{URCPU_RAKE_ROOT_DIR}/coverage.data")
end