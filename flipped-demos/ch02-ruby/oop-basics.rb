class BankAccount

  def initialize(starting_balance)
    @balance = starting_balance
    @error = ''
  end

  attr_reader :balance
  attr_reader :error
  
  def deposit(amount)
    @balance += amount
  end

  def withdraw(amount)
    if amount <= @balance
      @balance -= amount
    else
      @error = 'Sorry  not enough money'
      nil
    end
  end

end

# withdraw or deposit:
