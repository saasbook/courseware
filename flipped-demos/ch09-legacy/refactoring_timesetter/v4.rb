class DateCalculator
  attr_accessor :days, :year
  def initialize(days)
    @days = days
    @year = 1980
  end
  
  def convert
    while (days > 365) do
      if leap_year?
        add_leap_year
      else
        add_regular_year
      end
    end
    return year
  end
  
  # extracted methods
  def leap_year?
    (@year % 400 == 0 ||
      (@year % 4 == 0 && @year % 100 != 0))
  end
  
  def add_leap_year
    if (@days > 366) 
      @days -= 366
      @year += 1
    end
  end

  def add_regular_year
    @days -= 365
    @year += 1
  end
end

require 'rspec' unless defined?(RSpec)
describe DateCalculator do
  describe 'leap years' do
    before(:each) do
      @calc = DateCalculator.new(0)
    end
    def test_leap_year(year)
      @calc.year = year
      @calc.leap_year?
    end
    it 'should occur every 4 years' do
      expect(test_leap_year(2004)).to be_truthy
    end
    it 'but not every 100th year' do
      expect(test_leap_year(1900)).to be_falsy
    end
    it 'but YES every 400th year' do
      expect(test_leap_year(2000)).to be_truthy
    end
  end

  describe 'adding a leap year' do
    it 'should not peel off leap year if not enough days left' do
      @calc = DateCalculator.new(225)
      @calc.year = 2008
      expect { @calc.add_leap_year }.not_to change { @calc.year }
    end
    it 'should peel off leap year if >1 year of days left' do
      @calc = DateCalculator.new(400)
      @calc.year = 2008
      expect { @calc.add_leap_year }.to change { @calc.year }.by(1)
    end
    it 'should peel off leap year if exactly 1 year of days left' do
      @calc = DateCalculator.new(366)
      @calc.year = 2008
      expect { @calc.add_leap_year }.to change { @calc.year }.by(1)
    end      
  end
      
end
