# Ruby livecoding

## Ruby CLI

Everything in this directory is plain Ruby with no gems, so the only tools
you need are the ones that ship with Ruby itself.

* `ruby -v` -- which Ruby am I actually running?

* `ruby filename.rb` -- run a file and exit.

* `irb` -- the interactive Ruby shell.
Type an expression, see its value.  `exit` (or Ctrl-D) to quit.

  * **Load a file you just wrote.**  Note the leading `./`, which says "the
  file in this directory" rather than "an installed library":

    ```ruby
    require './courses_enrollments_students_v1'   # => true  (.rb is optional)
    Course.new('CS 169A', 12345, 2)
    ```

  * **Reload it after you edit it.**
    `require` deliberately loads a file only once! (This is handy for large programs, but a challange for exploring.) Instead, `load` re-runs the file
  (and *needs the exact path*, including the `.rb` ):

    ```ruby
    require './courses_enrollments_students_v1'   # => true
    # ...now edit the file in your editor...
    require './courses_enrollments_students_v1'   # => false -- nothing happened!
    load './courses_enrollments_students_v1.rb'   # => true  -- picks up the edit
    ```

    Existing objects keep whatever state they had, so it is often cleanest to
    re-create them after a `load`.

  * **Read the docs for a method** with `show_doc` (built into `irb`)

    ```ruby
    show_doc String#split
    show_doc Array#each
    ```

    Or from a shell, the `ri` command:

    ```shell
    $ ri String#split
    ```

  * **See a method's actual source**, which is the real payoff for methods
  you just defined together:

    ```ruby
    show_source Course#enroll
    Course.instance_method(:enroll).source_location   # => [".../courses...v1.rb", 30]
    ```

    `show_source` also works on library code you didn't write,
    which is an incredibly helpful way to learn about your frameworks and libraries.

  * `Course.instance_methods(false)` lists just the methods you defined, and
  `some_object.methods.sort` lists everything an object responds to.

## Class design

Suppose we are writing an app to manage students enrolling in
courses.  How would we model that?

* Start by building basic classes for a Student (name, SID number
initially) and a Course (title, CID number, enrollment limit)

* Add error logic for enrolling a student when the course is full.

* What other methods might you want to add to a course?  Implement
#drop (with error checking if you try to drop a student who was never
enrolled). 

**Implmentation Guidance:**
You can start building these example in three steps:

* `courses_enrollments_students_scaffold.rb`
* `courses_enrollments_students_v1.rb`
* `courses_enrollments_students_v2.rb` -- adds error reporting, `#full?`,
and `#drop`.

* `attr_reader :students` Wny not `attr_accessor`? Does this give you the protection you expect?
What happens if we try to modify `course.students`? How does this compare to other languages you have learned?

* Consider how you might model enrollments more generally. What other operations might you want to do?
What if you want to look up what courses a given student is enrolled in? If you have time, explore how to add
this and any potential downsides your implentation might have.


## Regular expressions

## Collections and functional idioms (collections.rb)

* `each` is the basic iterator in Ruby. Among other things, allows a
data structure to manage its own traversal.  Don't think of writing a
loop with index; let the data structure enumerate its own elements.

* Try `each` on an array.
Give exampes of "expression oriented" tasks:
  * capitalize each word of a name: `name.split(//).map(&:capitalize).join(' ')`
  * reject words in a list that contain non-word characters: `list.reject { |word| word =~ /\W/ }`

* Now try `each` on hashes, filehandles; why does it work? Mix ins!
  * explain mixins, methods we've seen are in Enumerable, give a demo of Comparable, and talk about sorting.

* Demo: how would you sort bank accounts? 
  * Sorting is defined in Enumerable, but also relies on Comparable.  So
  the receiver of `sort` must be enumerable via `each`, and the elements
  of the collection returend by `each` must be comparable.
  * So - add comparison to bank accounts!
  * This is "Ruby thinking"

## Metaprogramming (currency.rb)

* International bank account demo: adding individual methods to Numeric to allow conversions like `3.euros`
* Use of `method_missing` to create a DRYer more general solution
  * Note use of mixin: we put our stuff in a module to keep it self-contained, then include (mix in) the module into `Numeric`, which is the ancestor of the various numeric classes `Integer`, `Float`, etc.

## Yield

* What does `each` really do?  It yields one element of a collection at
a time, handing it to the lambda (procedure) that is the argument of
`each` itself!
* Strings don't have a built-in sort function, but we know that sorting
is available in `Enumerable` as long as the receiver object can respond
to `each`, and each yielded object can respond to `<=>`.  Is this true
for strings?  Let's try it.
  * No `each`, so we must define it. What if we made strings yield one
  character at a time?  If each character was yielded as a string of
  length 1, we know we can compare them.  So we just need to define
  `each` on strings, and include `Enumerable` to get the `sort` method
