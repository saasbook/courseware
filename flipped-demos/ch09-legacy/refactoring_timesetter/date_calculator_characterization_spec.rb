require 'simplecov'
SimpleCov.start
require './v0'
describe TimeSetter do
  { 365 => 1980, 900 => 1982, 366 => 1981 }.each_pair do |arg,result|
    it "#{arg} days puts us in #{result}" do
      expect(TimeSetter.convert(arg)).to eq(result)
    end
  end
end
