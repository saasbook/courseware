require 'redcarpet'
require 'rexml/document'

class Hw2Edxml
  class Chunker
    attr_reader :chunks
    def initialize(filename)
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :fenced_code_blocks => true, :tables => true)
      orig_md = File.read filename
      html = markdown.render(orig_md)
      wrapped_html = '<!DOCTYPE html><html><body>' << html << '</body></html>'
      File.open("/tmp/tmp.html", "w") { |f| f.puts wrapped_html }
      @doc = REXML::Document.new(wrapped_html)
      @elements = []
      validate_html
      @chunks = extract_chunks
    end

    private

    def validate_html
      raise(ArgumentError, 'root node must be <html>') unless @doc.root.name == 'html'
      raise(ArgumentError, 'no <body> found') unless @doc.root.elements['/html/body']
      @elements =  @doc.get_elements('/html/body/*')
      raise(ArgumentError, 'first element must be <h1>') unless vertical?(@elements.first)
    end

    #def ruql?(elt) ;  elt.name =~ /^script$/i && elt.attribute('language').to_s =~ /ruql/i ; end
    def ruql?(elt) ;  elt.name =~ /^pre$/i && elt.attribute('class').to_s =~ /ruql/i ; end
    def autograder?(elt) ; elt.name =~ /^div$/i && elt.attribute('class').to_s =~ /autograder/i ; end
    def vertical?(elt) ; elt.name =~ /^h1$/i ; end

    def extract_chunks
      # start from linear list of all the children of <body>.  Toplevel elements of resulting list
      # will all be Verticals, so once we start a new Vertical, subsequent chunks are consumed into it
      # until the next Vertical.
      # Note that #validate_html guarantees first element in overall list is a new vertical (h1).
      @chunks = []
      current_chunk = nil
      @elements.each do |elt|
        if vertical?(elt)
          current_chunk =  Hw2Edxml::VerticalChunk.new(elt)
          @chunks << current_chunk
        elsif ruql?(elt)
          current_chunk.chunks << Hw2Edxml::RuqlChunk.new(elt)
        elsif autograder?(elt)
          current_chunk.chunks << Hw2Edxml::AutograderChunk.new(elt)
        else # append to current HTML chunk, or start new HTML chunk if one is not active
          active_html_chunk = current_chunk.chunks.last
          unless active_html_chunk && (active_html_chunk.type == :html)
            active_html_chunk = Hw2Edxml::HtmlChunk.new            
            current_chunk.chunks << active_html_chunk
          end
          active_html_chunk.append_content(elt)
        end
      end
      @chunks
    end
  end
end
