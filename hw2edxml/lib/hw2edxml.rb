require 'yaml'
require 'fileutils'
require_relative 'hw2edxml/chunk'
require_relative 'hw2edxml/chunker'

class Hw2Edxml
  
  @@config = {} # :nodoc:
  
  # Autograder configuration info read from .yml file (hash with symbolized keys)
  def self.config
    @@config
  end
  # List of components that make up the homework
  attr_reader :chunks

  def run!
    begin
      @@config = read_config 'autograder/config.yml'
      @chunks = Chunker.new('public/README.md').chunks
    rescue Errno::ENOENT => e
      die_with "File not found: " + e.message +
        "\nMake sure you're running from the root directory of a homework assignment."
    end
    begin
      make_directories!
    rescue RuntimeError => e
      die_with "Unable to create directories: #{e.message}"
    end
    begin
      generate_xml_files!
    rescue RuntimeError => e
      die_with "Error generating XML: #{e.message}"
    end
  end

  private

  def make_directories!
    basename = 'studio'
    begin
      Dir.mkdir basename
    rescue Errno::EEXIST
      die_with "Directory '#{basename}' exists and would be overwritten, please remove it"
    end
    %w(sequential html vertical problem).each { |d| Dir.mkdir "#{basename}/#{d}" }
  end

  def generate_xml_files!
    chunks.each do |chunk|
      chunk.write_self!
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
