def q1i
  puts "Question 1.i"
  fruit1 = "strawberry"
  fruit2 = "banana"
  puts fruit1.reverse
  puts fruit2.reverse!
  fruit1 + " " + fruit2
end

class String
  @@hello = "hi there!"
  def hello; "world"; end
end

def q1ii
  puts "\nQuestion 1.ii"
  "smoothie".hello
end

class Fruit
  def method_missing(meth)
    if meth.to_s =~ /^tastes_(.*)\?$/
      "Yup, that fruit tastes #{$1}!"
    else
      super
    end
  end
end

def q1iii
  puts "\nQuestion 1.iii"
  orange = Fruit.new
  # orange.bitter? # Uncomment for MethodError
  puts orange.tastes_sour?
  orange.tastes_sweet?
end

def q2i(arr)
  puts "\nQuestion 2.i"
  arr.reduce(:+)
end

def q2ii(hsh)
  puts "\nQuestion 2.ii"
  hsh.select { |k, v| v > 100 }
end

def fib(n)
  puts "\nQuestion 3i"
  prev, curr = 0, 1
  n.times do
    yield curr
    prev, curr = curr, prev + curr
  end
end

class Array
  def odd_values
    puts "\nQuestion 3ii"
    self.values_at(* self.each_index.select {|i| i.odd?})
  end
end

puts q1i
puts q1ii
puts q1iii
puts q2i([10, 20, 30])
puts q2ii({"key1": 100, "key2": 101, "key3": 99, "key4": 102})
puts fib(4) { |x| puts x }
puts ('a'..'z').to_a.odd_values
