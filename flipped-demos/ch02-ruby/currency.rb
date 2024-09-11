# All a Number (a numeric in ruby) to have a method `to_yen`, `to_euros`, etc.
module CurrencyConversions
  @@currencies = {'yen' => 0.013, 'euro' => 1.292, 'rupee' => 0.019, 'usd' => 1 }
  def method_missing(method_id, *args, &block) # capture all args in case have to call super
    singular_currency = method_id.to_s..gsub(/^to_/, '').gsub( /s$/, '')
    if @@currencies.has_key?(singular_currency)
      self * @@currencies[singular_currency]
    else
      super
    end
  end
end

class Numeric
  include CurrencyConversions
end
