def running_under_textmate?
  ENV.keys.detect { |key| key =~ /^TM_/ }
end

if running_under_textmate?
  require 'cgi'
  
  module Kernel
    alias :original_puts :puts
    def puts(*args)
      args = args.map {|arg| convert_to_html(arg.to_s + "\n") }
      original_print *args
    end
  
    alias :original_p :p
    def p(*args)
      args = args.map {|arg| convert_to_html(arg.inspect + "\n") }
      original_print *args
    end
  
    alias :original_print :print
    def print(*args)
      args = args.map {|arg| convert_to_html(arg.to_s) }
      original_print *args
    end
  
    private

    def convert_to_html(string)
      CGI.escapeHTML(string).gsub(/\n/, "<br/>")
    end
  end
end