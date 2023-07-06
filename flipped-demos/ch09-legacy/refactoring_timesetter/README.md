# TimeSetter refactoring example

On December 31, 2008, all Microsoft Zune MP3 players that were booted up
on that day mysteriously froze.

If you rebooted on January 1, 2009, it would work again.

This is a Ruby transliteration of the buggy code that caused this bug,
[as explained in this
post](http://www.zuneboards.com/forums/showthread.php?t=38143).

`v0.rb` is the file containing the original (transliterated) buggy
code.  `v1.rb` is identical but has better variable names.

Start `irb`, say `load v1.rb`, and try to call the method
`DateCalculator.convert` with an argument of some number of days since
January 1, 1980 (the hardwired "day zero" origin date of the Zune's
clock chip), it should return what year it is given that number of days
elapsed since 1/1/80.

If you happen to call it with an argument whose value corresponds to the
last day of a leap year, then as the above article explains, the code
goes into an infinite loop.  Try 10593 (Dec 31, 2008) or 1827 (Dec 31,
1984).  You can decide whether to show this bug now, or show it later.

`v2.rb` renames variables to have more meaningful names, and extracts
the `leap_year?` method to improve readability.  It includes a spec to
test the extracted method; you can run it with `rspec v2.rb`, as well as
load the file interactively into `irb` and call
`DateCalculator.convert(arg)`.  Note that this file still 
contains the bug.

`v3.rb` extracts methods `add_leap_year` and `add_regular_year` and
encapsulates the logic in a class 
with instance variables to track the day and year.  This allows instance
methods to modify those values without having to pass them back and
forth and is a good example of the value of encapsulation.  You now have
to call it as `DateCalculator.new(arg).convert`.  Again, you can run
`rspec v3.rb` to run the tests.

`v4.rb` adds specs to test the newly-extracted `add_leap_year` and
`add_regular_year` methods.  One of the specs will fail, because of the
bug in `add_leap_year` (`> 366` should be `>= 366`).  `v5.rb` fixes that
bug and passes all the tests, and no longer has an infinite loop if you
try `DateCalculator.new(10593).convert`.

At each stage you can also run `flog `_filename_ on each file to see the
ABC scores of the methods, and `reek `_filename_ to see code smells.  By
the final refactoring, each method's flog score is well below 10, which
is the NIST recommended maximum for one function.
