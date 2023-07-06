class DateCalculator

  def self.convert(days)
    year = 1980
    while (days > 365) do
      if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0))
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
  
end

# try DateCalculator.convert(10592), then DateCalculator.convert(10593)
