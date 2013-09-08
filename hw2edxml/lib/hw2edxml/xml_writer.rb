require 'builder'

class Hw2Edxml
  class XmlWriter
    attr_reader :name, :config, :html
    attr_reader :errors
    attr_reader :output
    def initialize(name, config, html)
      @name, @config, @html = name, config, html
      @errors = ''
      @output = ''
      @xml = Builder::XmlMarkup.new(:target => @output, :indent => 2)
    end

    def generate
      @xml.problem do
        @xml.startouttext
        @xml << self.html
        @xml.p 'Please place all the code for this problem in a single file and upload it using the form below:'
        @xml.endouttext
        @xml << self.autograder_form
      end
    end

    def valid?
      errors = []
      %w(points grader_payload queuename).each do |property|
        if !config.has_key?(property) || config[property].to_s.empty?
          errors << "missing required attribute '#{property}'"
        end
      end
      errors << "points must be >0" unless config['points'].to_i > 0
      if errors.empty?
        true
      else
        @errors = "Problem '#{name}': " + errors.join('; ')
        false
      end
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
  end
end
