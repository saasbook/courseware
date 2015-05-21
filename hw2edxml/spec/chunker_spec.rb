require 'spec_helper'
require 'hw2edxml/chunker'

describe 'chunkifying' do
  describe 'valid file' do
    before(:each) do
      @chunker = Hw2Edxml::Chunker.new('spec/fixtures/valid_5_chunk.html')
    end
    it 'has 3 verticals' do
      expect(@chunker.chunks.length).to eq(3)
    end
    it 'has correct chunk types' do
      expect(@chunker.chunks.map(&:type)).to eq([:vertical, :vertical, :vertical])
    end
  end
  it 'should accept valid file' do
    expect { Hw2Edxml::Chunker.new('spec/fixtures/valid_5_chunk.html') }.not_to raise_error
  end
  describe 'invalid file' do
    tests = {
      'invalid_root_not_html' => 'root node must be <html>',
      'invalid_no_body' => 'no <body> found',
      'invalid_content_outside_divs' => 'first element must be <h1>',
    }
    tests.each_pair do |fixture, error|
      it "when #{fixture} should report #{error}" do
        expect { Hw2Edxml::Chunker.new("spec/fixtures/#{fixture}.html") }.
          to raise_error(ArgumentError, Regexp.new(error))
      end
    end
  end
end
