require 'yaml'
require 'github-markup'

require 'hw2edxml/xml_writer'

class Hw2Edxml
  attr_accessor :config
  def run!
    @config = read_config
  end
  
  def initialize
    @config = {}
  end


  private

  def read_config
    begin
      YAML::load(IO.read('autograder/config.yml'))
    rescue Errno::ENOENT
      die_with "Can't find autograder/config.yml.\nMake sure you're running from root directory of a homework assignment."
    end
  end

  def die_with(msg)
    STDERR.puts msg
    exit 1
  end
    
end
