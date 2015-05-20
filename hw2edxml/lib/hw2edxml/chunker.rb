require 'github/markup'
require 'rexml/document'
require 'debugger'

class Hw2Edxml
  class Chunker
    attr_reader :chunks
    def initialize(filename)
      html = GitHub::Markup.render(filename)
      @doc = REXML::Document.new(html)
      @elements = []
      validate_html
      @chunks = extract_chunks
    end

    private

    def validate_html
      raise(ArgumentError, 'root node must be <html>') unless @doc.root.name == 'html'
      raise(ArgumentError, 'no <body> found') unless @doc.root.elements['/html/body']
      @elements =  @doc.get_elements('/html/body/*')
      first_elt = @elements.first
      raise(ArgumentError, 'first element must be <h1>, <script language="ruql">, or <div class="autograder">') unless
        ruql?(first_elt) || autograder?(first_elt) || vertical?(first_elt)
      # check divs have unique names
      divs = @doc.get_elements("/html/body/div[@class='autograder']")
      if divs.any? { |elt| elt.attribute('data-display-name').to_s.empty? }
        raise(ArgumentError, "all autograder <div>s must have a 'data-display-name' attribute")
      end
      names = divs.map { |elt| elt.attribute('data-display-name').to_s }
      if names.length != names.uniq.length
        raise(ArgumentError, 'autograder names must be unique')
      end
    end

    def ruql?(elt) ;  elt.name =~ /^script$/i && elt.attribute('language').to_s =~ /ruql/i ; end
    def autograder?(elt) ; elt.name =~ /^div$/i && elt.attribute('class').to_s =~ /autograder/i ; end
    def vertical?(elt) ; elt.name =~ /^h1$/i ; end

    def extract_chunks
      # start from linear list of all the children of <body>.
      @chunks = []
      @elements.each do |elt|
        if    ruql?(elt)       then @chunks << Hw2Edxml::RuqlChunk.new(elt)
        elsif autograder?(elt) then @chunks << Hw2Edxml::AutograderChunk.new(elt)
        elsif vertical?(elt)   then @chunks << Hw2Edxml::VerticalChunk.new(elt)
        else # append to current HTML chunk
          @chunks << Hw2Edxml::HtmlChunk.new unless @chunks.last.type == :html
          @chunks.last.append_content(elt)
        end
      end
      @chunks
    end
  end
end
