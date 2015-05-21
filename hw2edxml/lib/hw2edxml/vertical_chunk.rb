class Hw2Edxml::VerticalChunk < Hw2Edxml::Chunk

  # This is the only kind of chunk that can contain other chunks, so we override #to_edxml
  # and #write_self! to recursively output them.
  
  attr_accessor :chunks

  def initialize(elt)
    @chunks = []
    super(elt.to_s, elt.text)
  end

  def to_edxml
    @xml.vertical(:display_name => display_name) do
      chunks.each do |chunk|
        @xml.__send__(chunk.type, :url_name => chunk.id)
      end
    end
    @output
  end

  def write_self!
    super # first, write the vertical/999.xml file
    chunks.each { |chunk| chunk.write_self! } # the nested chunks
  end

end
