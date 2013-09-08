require 'spec_helper'
require 'hw2edxml/xml_writer'

describe 'generating XML for Studio' do
  before :each do
    @config = {
      'queuename' => 'q1',
      'points' => 50,
      'grader_payload' => 'hw0-problem1'
    }
  end
  context 'with valid config and markup' do
    before :each do
      @name = 'problem1'
      @html = '<h1>two-element</h1> <h2>explanation</h2>'
      @xml_writer = Hw2Edxml::XmlWriter.new(@name, @config, @html)
    end
    describe 'generating autograder form' do
      subject { @xml_writer.autograder_form }
      it { should have_xml_element('coderesponse').with_attribute('queuename', 'q1') }
      it { should have_xml_element('coderesponse/filesubmission').with_attribute('points', '50') }
      it { should have_xml_element('coderesponse/codeparam') }
      it { should have_xml_element('coderesponse/codeparam/grader_payload').with_value('hw0-problem1') }
    end
    describe 'generating overall page' do
      before :each do
        @xml_writer.stub(:autograder_form).and_return('<codeparam></codeparam>')
        @result = REXML::Document.new(@xml_writer.generate).root
      end
      %w(startouttext h1 h2 p endouttext codeparam).each_with_index do |elt, index|
        it "child #{index+1} should be '#{elt}'" do
          @result.elements[index+1].name.should == elt
        end
      end
    end
    context 'with a custom prompt' do
      subject do
        @xml_writer.stub(:autograder_form).and_return('<codeparam></codeparam>')
        @config['prompt'] = 'Custom Prompt'
        @xml_writer.generate
      end
      it { should have_xml_element('problem/p', :value => 'Custom Prompt') }
      it { should_not have_xml_element('problem/p', :value => Hw2Edxml::XmlWriter::DEFAULT_PROMPT) }
    end
  end

  context 'when config data are missing' do
    it 'requires queuename' do
      expect { @config.delete('queuename') ; Hw2Edxml::XmlWriter.new('x', @config, '') }.
        to raise_error(ArgumentError, "Problem 'x': missing required attribute 'queuename'")
    end
    it 'requires nonzero points' do
      expect { @config['points'] = -1 ; Hw2Edxml::XmlWriter.new('x', @config, '') }.
        to raise_error(ArgumentError, "Problem 'x': points must be >0")
    end
  end

end


