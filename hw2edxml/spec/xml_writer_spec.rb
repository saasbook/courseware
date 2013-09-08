require 'spec_helper'
require 'hw2edxml/xml_writer'

describe 'generating XML for Studio' do

  context 'with valid config and markup' do
    before :each do
      @name = 'problem1'
      @chunk_config = {
          'queuename' => 'q1',
          'points' => 50,
          'grader_payload' => 'hw0-problem1'
        }
      @html = '<h1>Problem explanation</h1> <p>Directions here</p>'
      @xml_writer = Hw2Edxml::XmlWriter.new(@name, @chunk_config, @html)
    end
    specify { @xml_writer.should be_valid }
    subject { @xml_writer.autograder_form }
    it { should have_xml_element('coderesponse').with_attribute('queuename', 'q1') }
    it { should have_xml_element('coderesponse/filesubmission').with_attribute('points', '50') }
    it { should have_xml_element('coderesponse/codeparam') }
    it { should have_xml_element('coderesponse/codeparam/grader_payload').with_value('hw0-problem1') }
  end

  context 'when config data are missing'

  context 'when config has multiple keys' do
    it 'should be an error'
  end
end


