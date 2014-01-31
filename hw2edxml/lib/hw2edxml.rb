require 'yaml'
require_relative 'hw2edxml/xml_writer'
require_relative 'hw2edxml/chunker'

class Hw2Edxml
  attr_accessor :config, :chunks
  def run!
    begin
      @config = read_config 'autograder/config.yml'
      @chunks = Chunker.new 'public/README.md'
    rescue Errno::ENOENT => e
      die_with "File not found: " + e.message +
        "\nMake sure you're running from the root directory of a homework assignment."
    end
    check_for_missing_keys!
    generate_xml_files!
  end
  
  def initialize
    @config = {}
    @chunks = {}
  end


  private

  def generate_xml_files!
    chunks.each_pair do |problem_name, problem_html|
      begin
        File.open("#{problem_name}.xml", "w") do |f|
          f.write XmlWriter.new(problem_name, config[problem_name], problem_html)
        end
      rescue RuntimeError => e
        die_with "Writing #{problem_name}.xml: " + e.message
      end
    end
  end
  
  def check_for_missing_keys!
    missing_from_config = chunks.keys - config.keys
    unless missing_from_config.empty?
      die_with "Keys #{missing_from_config.join ','} referenced in README.md but not in config.yml"
    end
    missing_from_chunks = config.keys - chunks.keys
    unless missing_from_chunks.empty?
      die_with "Keys #{missing_from_chunks.join ','} referenced in config.yml but not in README.md"
    end
  end
  
  def read_config(file)
    begin
      YAML::load(IO.read file)
    rescue Errno::ENOENT
      die_with "Can't find #{file}.\nMake sure you're running from root directory of a homework assignment."
    end
  end

  def die_with(msg)
    STDERR.puts msg
    exit 1
  end
    
end
