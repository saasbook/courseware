class DateCalculator

  def convert(days)
    year = 1980
    while (days > 365) do
      if leap_year?(year)
        if (days > 366) 
          days -= 366
          year += 1
        end
      else
        days -= 365
        year += 1
      end
    end
    return year
  end
  
  # extracted method
  def leap_year?(year)
    (year % 400 == 0 ||
      (year % 4 == 0 && year % 100 != 0))
  end
  
end

require 'rspec' unless defined?(RSpec)
describe DateCalculator do
  describe 'leap years' do
    before(:each) do ; @calc = DateCalculator.new ; end
    it 'should occur every 4 years' do
      expect(@calc.leap_year?(2004)).to be_truthy
    end
    it 'but not every 100th year' do
      expect(@calc.leap_year?(1900)).to be_falsy
    end
    it 'but YES every 400th year' do
      expect(@calc.leap_year?(2000)).to be_truthy
    end
  end
end
