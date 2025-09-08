class Color
  # define setter methods only
#  attr_writer :r, :g, :b
  # define setters and getters
  attr_accessor :r, :g, :b
  # define getters only
  #  attr_reader :r, :g, :b

 def initialize(r, g, b)
   @r = clamp(r)
   @g = clamp(g)
   @b = clamp(b)
 end

 def +(other)
   Color.new(@r + other.r, @g + other.g, @b + other.b)
 end

 def -(other)
   Color.new(@r - other.r, @g - other.g, @b - other.b)
 end

 def to_s
   "#%02X%02X%02X" % [@r, @g, @b]
 end

 private

 def clamp(value)
   [[value, 0].max, 255].min
 end
end
