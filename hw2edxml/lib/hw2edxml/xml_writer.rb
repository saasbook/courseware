require 'builder'

class Hw2Edxml
  class XmlWriter
    attr_reader :name, :config, :html
    attr_reader :output

    DEFAULT_PROMPT = 
      'Please place the solution for this problem in a single file and upload it using the form below:'
    
    def initialize(name, config, html)
      @name, @config, @html = name, config, html
      if (errors = validate_instance())
        raise(ArgumentError, errors)
      end
      @output = ''
      @xml = Builder::XmlMarkup.new(:target => @output, :indent => 2)
    end

    def generate
      @xml.problem do
        @xml.startouttext
        @xml << self.html
        @xml.p  @config['prompt'] || DEFAULT_PROMPT
        @xml.endouttext
        @xml << self.autograder_form
      end
      @output
    end

    def autograder_form
      form = ''
      xml = Builder::XmlMarkup.new(:target => form, :indent => 2)
      xml.coderesponse(:queuename => config['queuename']) do
        xml.filesubmission(:points => config['points'])
        xml.codeparam do
          xml.grader_payload config['grader_payload']
        end
      end
      form
    end

    def validate_instance
      errors = []
      %w(points grader_payload queuename).each do |property|
        if !@config.has_key?(property) || @config[property].to_s.empty?
          errors << "missing required attribute '#{property}'"
        end
      end
      errors << "points must be >0" unless @config['points'].to_i > 0
      return errors.empty? ? nil : ("Problem '#{name}': " + errors.join(', '))
    end

  end
end
