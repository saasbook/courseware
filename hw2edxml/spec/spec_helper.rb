require 'debugger'
Dir[File.join(File.dirname(__FILE__), '..', 'lib', '*.rb')].each { |f|  load f }
Dir[File.join(File.dirname(__FILE__), '/support', '**', '*.rb')].each {|f| load f}
