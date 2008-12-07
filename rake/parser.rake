namespace :parser do
  SOURCE = "#{URCPU_RAKE_ROOT_DIR}/doc/urscheme/urscheme.s"
  LIMIT = 25

  desc "Display the first #{LIMIT} lines of #{SOURCE} that can't be parsed"
  task :coverage => [:urcpu] do
    UrCPU::Rake::ParserCoverage.new(SOURCE, LIMIT).run
  end

  namespace :coverage do
    desc "Display all lines of #{SOURCE} that can't be parsed"
    task :all => [:urcpu] do
      UrCPU::Rake::ParserCoverage.new(SOURCE, nil).run
    end
  end
end

module UrCPU
  module Rake
    class ParserCoverage
      def initialize(file, limit = nil)
        @limit = limit
        @file_name = file
        @file = File.open(@file_name, "r")
        @parser = UrCPU::Assembler::Parser.new
      end
      
      def run
        unparsed = Array.new
        line_num = 0
        @file.readlines.each do |line|
          line_num += 1
          unless @parser.parse_line(line)
            unparsed << "#{File.basename @file_name}:#{line_num} #{line}"
            break if unparsed.size == @limit
          end
        end
        display_report unparsed, line_num
      end
      
      def display_report(unparsed, max_line)
        puts unparsed[0, @limit || unparsed.size].join("")
        puts
        parsed = max_line - unparsed.size
        printf("Parsed: %.3f%% (%d/%d)\n", 
               100.0*parsed.to_f/max_line.to_f, parsed, max_line)
      end
    end
  end
end