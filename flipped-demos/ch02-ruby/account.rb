class Account
  include Comparable

  def <=>(other)
    self.balance <=> other.balance
    # wait, isn't this infinite recursion?!?
  end

  attr_accessor :balance
  def initialize(balance=0)
    @balance=balance
  end
end
