require 'spec_helper'
describe Hw2Edxml::VerticalChunk do

  describe 'outputs nested XML' do
    before :each do
      @chunks = [
        double('chunk1', :type => 'problem', :id => 'p1'),
        double('chunk2', :type => 'html', :id => 'h1'),
        double('chunk3', :type => 'problem', :id => 'r1')
      ]
      @subj = Hw2Edxml::VerticalChunk.new(REXML::Document.new('<h1>Foo</h1>'))
      @subj.chunks = @chunks
    end 
    subject { @subj.to_edxml }
    it { should have_xml_element('vertical').with_attribute(:display_name, 'Foo') }
    it { should have_xml_element('vertical/problem').with_attribute(:url_name, 'p1') }
  end
end
