require 'github/markup'
require 'rexml/document'
require 'debugger'

class Hw2Edxml
  class Chunker
    attr_reader :chunks
    def initialize(filename)
      html = GitHub::Markup.render(filename)
      @doc = REXML::Document.new(html)
      @chunks = {}
      validate_html
      extract_divs
    end

    def validate_html
      raise(ArgumentError, 'root node must be <html>') unless @doc.root.name == 'html'
      raise(ArgumentError, 'no <body> found') unless @doc.root.elements['/html/body']
      body_children =  @doc.get_elements('/html/body/*')
      if body_children.any? { |elt| (elt.name != 'div') || (elt.attribute('class').to_s != 'problem') }
        raise(ArgumentError, 'all content must be inside <div class="problem">')
      end
      # check divs have unique names
      divs = @doc.get_elements("/html/body/div[@class='problem']")
      if divs.any? { |elt| elt.attribute('name').to_s.empty? }
        raise(ArgumentError, "all problem <div>s must have a 'name' attribute")
      end
      names = divs.map { |elt| elt.attribute('name').to_s }
      if names.length != names.uniq.length
        raise(ArgumentError, 'problem names must be unique')
      end
    end

    def extract_divs
      @doc.root.each_element("//div[@class='problem']") do |elt|
        @chunks[elt.attributes['name']] = elt.children.join
      end
      @chunks
    end
  end
end
