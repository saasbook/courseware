# Give strings the ability to respond to each

class String
  def each
    self.split(//).each do |char|
      yield char
    end
  end
end
