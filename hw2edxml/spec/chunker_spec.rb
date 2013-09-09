require 'spec_helper'
require 'hw2edxml/chunker'

describe 'chunkifying' do
  describe 'valid file with 3 problems' do
    before(:each) { Hw2Edxml::Chunker.any_instance.stub(:validate_html) }
    subject { Hw2Edxml::Chunker.new('spec/fixtures/valid_3_chunk.html').chunks }
    it { should have(3).keys }
    it 'should extract chunk names from div "name" attribute' do
      %w(p1 p2 p3).each { |key| subject.should have_key(key) }
    end
    it 'should extract HTML from contents of div' do
      %w(p1 p2 p3).each_with_index { |key,index| subject[key].should == "<p>problem #{index+1}</p>" }
    end
  end
  it 'should accept valid file' do
    expect { Hw2Edxml::Chunker.new('spec/fixtures/valid_3_chunk.html') }.not_to raise_error
  end
  describe 'invalid file' do
    tests = {
      'invalid_root_not_html' => 'root node must be <html>',
      'invalid_no_body' => 'no <body> found',
      'invalid_content_outside_divs' => 'all content must be inside <div class="problem">',
      'invalid_div_without_class' => 'all content must be inside <div class="problem">',
      'invalid_div_without_name' => "all problem <div>s must have a 'name' attribute",
      'invalid_names_not_unique' => 'problem names must be unique',
    }
    tests.each_pair do |fixture, error|
      it "when #{fixture} should report #{error}" do
        expect { Hw2Edxml::Chunker.new("spec/fixtures/#{fixture}.html") }.
          to raise_error(ArgumentError, Regexp.new(error))
      end
    end
  end
end
