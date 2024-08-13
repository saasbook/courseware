# **Module 2 Problems**

Correct answers are either **bolded** or indicated with #answer. 

## Ruby Truthy 

Consider the following Ruby code:

Which of the following can fill in the blank to print out “yay!”

**a[3]['yummy']**

**a[4]**

**a[1]**

a[-1]

a[-4]

**a.include?(:CHEESE)**

## Ruby Errors 

Suppose that a and b are objects of arbitrary types in Ruby. Which of the following lines of code would definitely not result in a runtime error?

**a.equal?(b)**

**a.nil?**

c = a + b

a.each{ |x| puts x}

**a.respond_to?(:to_s)**

## Ruby Iteration 

Suppose x is an array of integers in Ruby, and you want to destructively increment each element of x by 1. Select all of the choices that accomplish this without error:

```ruby
x.each do |element|

     element += 1

end
```
```ruby
x.each_with_index do |element, index| #answer

    x[index] = element + 1

end
```
```ruby
x.map {|element| element + 1}
```
```ruby
x.map! {|element| element + 1} #answer
```

## Ruby Regex 

You want to write a regex pattern that validates someone’s first name. The name must begin with an uppercase letter, be followed by lowercase letters, and be at least 2 characters long. Which of the following regex patterns accomplishes this in Ruby?

**[A-Z][a-z]+**

[A-Z]\w+

[^a-z0-9\s][a-z]+

**[A-Z][a-z]{1,}**

[A-Z][a-z]?[a-z]*

## Ruby Arithmetic

Suppose a, b, and c are integers in Ruby. Which of the following are equivalent to the expression (a + b) / c?

**a.send(:+, b).send(:/, c)**

a.send(:/, c).send(:+, b.send(:/, c))

**a.+(b)./(c)**

a./(c).+(b./(c))

a.send(:-, -b).send(:*, 1/c)

## Pair programming 

Pair programming tends to:

Be less expensive than solo programming

**Yield code solutions of higher quality for more complex tasks**

**Result in reduced development time compared to solo programming**

Work effectively when both collaborators are thinking about different issues in parallel throughout the process

**Work effectively when the pair takes turns switching between roles of driver and observer**

## Fruits Part 1

Consider this Ruby code:

```ruby
class Fruit
     
    def initialize(fruit_name, price)
          @name = fruit_name
          @price = price
    end

    def <=>(other)
        if @price == other.price
            other.name <=> @name
        else
            @price <=> other.price
        end
    end
end
```

The code inside the &lt;=> function will error if you are not able to view the value of a fruit’s name and price. Which lines of code could you insert inside the class to accomplish this?
```ruby
def name      #answer
    @name
end
def price
    @price
end
```
```ruby
attr_reader :name #answer
attr_accessor :price
```
```ruby
attr_accessor :name #answer
attr_accessor :price
```
```ruby
attr_writer :name #does not work (attr_writer does not give read access)
attr_accessor :price
```

## Fruits Part 2

Consider this Ruby code:

```ruby
class Fruit
    attr_reader :price
    attr_reader :name
    def initialize(fruit_name, price)
          @name = fruit_name
          @price = price
    end

    def <=>(other)
        if @price == other.price
             other.name <=> @name
        else
           @price <=> other.price
        end
    end
end

apple = Fruit.new(:apple, 4)
banana = Fruit.new(:banana, 3)
orange = Fruit.new(:orange, 3)
fruits = [apple, banana, orange].sort
```

Which of the following statements are true (or evaluate to true)?

Fruit can mix-in the Enumerable module

**Fruit can mix-in the Comparable module**

**fruits.map {|x| x.price} == [3, 3, 4]**

fruits.map {|x| x.name} == [:banana, :orange, :apple]

**fruits.sort_by{|x| x.name}.reverse.map{|x| x.price} == [3, 3, 4]**

banana &lt; apple 

## Vegetables Part 1

```ruby
class Vegetable
	@@valid_vegetables = [:potato, :carrot, :squash, :zucchini]
	attr_reader :name
	def initialize(name=nil)
		@name = name
	end

	def name=(name)
		if @@valid_vegetables.include?(name)
			@name ||= name
		end
	end
end
```

Which of the following code changes effectively makes the name attribute of **every possible instance** of the Vegetable class immutable?

**Change:**
```ruby 
@@valid_vegetables = [:potato, :carrot, :squash, :zucchini] #answer
```
**To:**
```ruby
@@valid_vegetables = [] #answer
```

**Delete the name= method entirely**

Change:
```ruby
def initialize(name=nil)
```
To: 
```ruby
def initialize(name)
```
Remove attr_reader :name

**Change the initialize method to take no arguments and instead read:**
```ruby
def initialize #answer
    @name = :carrot
end
```

## Vegetables Part 2

After declaring the vegetables class, we run the following lines:

```ruby
#declare vegetables 
anonymous = Vegetable.new 
potato = Vegetable.new(:potato) 

#set some random values 
val = anonymous.name or potato.name 
val_2 = !anonymous.name && potato.name
 
#modify vegetables 
anonymous.name = :carrot 
potato.name = :zucchini
```

Which of the following are true?

potato.name == :zucchini

**anonymous.name == :carrot**

val == :potato

**val_2 == :potato**

**!(val and val_2)**

