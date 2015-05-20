require 'spec_helper'
require 'hw2edxml/chunk'
require 'rexml/document'

describe 'Autograder XML block' do
  context 'when valid' do
    before :each do
      @raw = REXML::Document.new(%q{
    <div class="autograder" data-display-name="Submit" data-points="50" data-grader-payload="p1q1">  <!-- chunk 3: autograder -->
      <h2>Header</h2>
      <p>Submit your solution.</p>
    </div>
}).get_elements('*').first
      allow(Hw2Edxml).to receive(:config).and_return({:queue_name => 'q1'})
    end
    describe 'when created' do
      subject { Hw2Edxml::AutograderChunk.new(@raw)  }
      its(:grader_payload) { should == 'p1q1' }
      its(:points) { should == '50' }
      its(:display_name) { should == 'Submit' }
    end
    describe 'autograder form' do
      subject { Hw2Edxml::AutograderChunk.new(@raw).autograder_form }
      it { should have_xml_element('coderesponse').with_attribute('queuename', 'q1') }
      it { should have_xml_element('coderesponse/filesubmission').with_attribute('points', '50') }
      it { should have_xml_element('coderesponse/codeparam') }
      it { should have_xml_element('coderesponse/codeparam/grader_payload').with_value('hw0-problem1') }
    end
    describe 'output' do
      subject { REXML::Document.new(Hw2Edxml::AutograderChunk.new(@raw).to_edxml)  }
      it 'has a single <problem> element' do
        expect(subject.elements[1].name).to eq('problem')
        expect(subject.elements.count).to eq(1)
      end
      it 'includes correct subelements' do
        problem = subject.get_elements('problem')[0]
        %w(startouttext div endouttext coderesponse).each_with_index do |elt, index|
          expect(problem.elements[index+1].name).to eq(elt)
        end
      end
    end
  end

end


