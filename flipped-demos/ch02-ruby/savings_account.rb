class Account
end

class SavingsAccount < Account    # inheritance
  # constructor used when SavingsAccount.new(...) called 
  def initialize(starting_balance=0) # optional argument
    @balance = starting_balance
  end
  def balance	 # instance method
    @balance   # instance var: visible only to this object
  end
  def balance=(new_amount)  # note method name: like setter
    @balance = new_amount
  end
  def deposit(amount)
    @balance += amount
  end
  @@bank_name = "MyBank.com"    # class (static) variable  
  # A class method
  def self.bank_name   # note difference in method def
    @@bank_name
  end
  # or: def SavingsAccount.bank_name ; @@bank_name ; end
end
