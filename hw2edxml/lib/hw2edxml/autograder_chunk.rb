require 'builder'

class Hw2Edxml::AutograderChunk < Hw2Edxml::Chunk

  # Grader payload for XQueue submission
  attr_reader :grader_payload
  # Queue name for XQueue submission
  attr_reader :queue_name
  # Points for assignment
  attr_reader :points
  
  def initialize(elt)
    @grader_payload = elt.attribute('data-grader-payload').to_s
    @points = elt.attribute('data-points').to_s
    @queue_name = Hw2Edxml.config[:queue_name]
    super(elt.elements.map(&:to_s).join(''), Hw2Edxml::Chunk.name_for(elt))
  end

  def type ; :problem ; end

  def to_edxml
    @xml.problem do
      @xml.startouttext
      @xml << @raw_data
      @xml.endouttext
      @xml << self.autograder_form
    end
    @output
  end


  def autograder_form
    form = ''
    xml = Builder::XmlMarkup.new(:target => form, :indent => 2)
    xml.coderesponse(:queuename => queue_name) do
      xml.filesubmission(:points => points)
      xml.codeparam do
        xml.grader_payload grader_payload
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
