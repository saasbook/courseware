# each

x = ['apple','cherry','apple','banana']

x.each do |fruit|
  puts fruit
end

# In what class is the method getting called?
x.method(:each)

# Collection idioms

x.sort 
x.uniq.reverse 
x.reverse!  
x.map do |fruit|
  fruit.reverse
end.sort 
  
x.collect { |f| f.include?("e") }
x.any? { |f| f.length > 5 }


{}.method(:each)
file = File.open("/tmp/collections.rb")
file.each do |line|
  puts line
end

class String
  def each
    chars = self.split(//)
    chars.each do |ch|
      yield ch
    end
  end
end

"abcde".each do |char|
  puts char
end
