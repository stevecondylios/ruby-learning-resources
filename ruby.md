
# Installation

Recommended for macOS: follow [instructions](https://github.com/rbenv/rbenv?tab=readme-ov-file#using-package-managers) to install rbenv *and* ruby-build (using homebrew), then:

```sh
rbenv install --list # shows available versions
rbenv install 3.3.0 # installs version 3.3.0
rbenv versions # shows installed versions, with * next to the one in use
# To alter the version in use, typically edit a file like /Users/<username>/.rbenv/version
```


# First things first

Some quick examples of how the language works and some "idiomatic ruby". Mostly from [here](http://cbcg.net/talks/rubyidioms/) (tap to go to next page of slideshow).

```ruby

2 * 2
# 4


s = "Hello!"

p s # prints string
pp s # pretty prints string


x = 5
x -= 3 # minusequals takes 3 away from x
x += 7 # plusequals adds 7 to x

# the 'match operator' matches a regular expression on the left with a string on the right and
# provides the offset, otherwise nil. See: https://stackoverflow.com/a/5781400

/away/ =~ "give it away now"
# 8

/know/ =~ "give it away now"
# nil

# Note: it seems not to matter which side the regex is on: /ell/ =~ "hello" is the same as "hello" =~ /ell/

# threeequals asks: does the thing on the right belong on in the set on the left
(1..5) === 4
# true

(1..5) === 10
# false

String === "hi"
# true



# unless works like 'if not'

no_time_to_talk = false
puts "hey there" unless no_time_to_talk
# hey there

# A note about unless
# Recall that the two falsey values in ruby are false and nil, everything else is truthy (I think)
# So something like 
puts "hi" unless 5
# won't print because 5 is 'truthy', which can be a little surprising first time around
# Also, 
b = 55
puts "hi" unless b
# That will also not print because b is 55, and that's again truthy. Just be aware that unless doesn't have to be provided some very obvious `true` for it to work. Use to your advantage, for example https://github.com/rails/rails/blob/577274d57d57df35f99655d0923252a6d9879090/activerecord/lib/active_record/tasks/database_tasks.rb#L555



# until works like 'while not'
x = 2
while x > -5 do 
  puts x
  x -= 1
end
# 2
# 1
# 0
# -1
# -2
# -3
# -4



__FILE__ # is the name of the current source file
$0 # at the top level is the name of the top-level program being executed
$: # is an array of paths to look for Ruby scripts to load
$! # is the current Exception passed to raise 

ENV # is the hash of environment variables
ARGV # is the array of command line arguments (synonym for $*)
```


Conventions:

- Methods ending in `?` return boolean
- Methods ending in `!` are dangerous (they modify the receiver) 
  - Note that in rails, the `!` (or 'bang') often means "raise an error if the method doesn't work" e.g. `update!(age: "lskdjfs")` 
- These are optional but make code readable



- Ruby considers `nil` and `false` the only two "falsey" values, everything else is "truthy". Source [here](https://stackoverflow.com/a/3082399/5783745)



```ruby

# Conditional assignment operator
a ||= b # means if a doesn't exist or is falsy, assign it the value of b
# Read more: https://stackoverflow.com/a/14697343

a = nil
b = 5
a ||= b 
# now a is 5

a = false
b = 5
a ||= b 
# a is now 5 


s ||= "hello" # is the same as

s = "hello" if (s.nil? || s == false)
```



By default, object attributes cannot be read or written from outside the object. You can change the access on attributes with `attr_writer` and `attr_reader` (or `attr_accessor` which does both). These are class methods that open the named attributes up to reading and writing. 

Let's put this to the test:

```ruby
class Thing
end

t = Thing.new

t.name
# undefined method `name' for Thing

class Thing
  attr_accessor :name, :age
end

t.name
# => nil

t.name = "Joe"
# => "Joe"

t.name
# => "Joe"

```

We can do something similar but use `initialize` which is a special ruby method which, when defined, will let you set attributes when the instance is created. Note that `def initialize(name, age)` would *require* those attributes, whereas `def initialize(name: nil, age: nil)` allows them to be optionally provided


```ruby
class Thing
  attr_accessor :name, :age
  def initialize(name: nil, age: nil)
    @name = name
    @age = age
  end
end

t = Thing.new
t.name
# nil
t.name = "John"
t.name
# => John

s = Thing.new(name: "Sue", age: 99)
s.name
# => Sue
s.age
# => 99
```










You can write virtual attributes too. Example

```ruby

class RubyBean # a play on 'JavaBean', some minimal Java object
  attr_reader :name, :date, :location

  def name=(str)
    @name = str.titleize
  end
end

x = RubyBean.new
x.name = "frank"
p x.name
# Frank

```


**Exception handling** 

Catch exceptions with `begin` and `rescue`

```ruby

begin 
  2 * "hi"
rescue => e 
  $stderr.puts "error: #{e.message}"
end

# error: String can't be coerced into Integer

```

`ensure` makes sure the code is called regardless of outcome

```ruby

begin
  2 * "hi"
rescue => e
  $stderr.puts "error: #{e.message}"
ensure
  puts "Something that MUST run, e.g. close a connection to a file with f.close"
end

```

You can raise your own exceptions with `raise`. `raise` can be used with `String` or `Exception` objects. 

```ruby
raise
raise StandardError.new
raise "failure to raise resource ABC"
```

`fail` is an alias for `raise`, they can be used interchangably. Some exceptions cannot be caught unless explicity caught in `rescue`. 



Exception handling in a loop 

Example: you have a list of emails and an email could bounce, causing an error, but you want to ensure the loop continues to try to send to the remaining emails


```ruby

arr = [1, 2, 4]
arr.each_with_index do |el, i|
  arr[i] = el + 2
end
# [12, 4, 6]



arr = [1, 2, "cats and dogs", 4]
arr.each_with_index do |el, i|
  arr[i] = el + 2
end
# in `+': no implicit conversion of Integer into String (TypeError)
arr
# [3, 4, "cats and dogs", 4] <--- big problem! code ran on elements before
# the error but not after!


# Solution
arr = [1, 2, "cats and dogs", 4]
arr.each_with_index do |el, i|
  begin
    arr[i] = el + 2
  rescue => e
    $stderr.puts "error: #{e.message}"
  end
end
# error: no implicit conversion of Integer into String
# => [3, 4, "cats and dogs", 6]
# sc: this time, the code ran on each element in the array, and raised an
# error|exception on the item that cause a problem


# Same as above, but with custom error
# (need to flesh out my understanding here)
arr = [1, 2, "cats and dogs", 4]
arr.each_with_index do |el, i|
  begin
    arr[i] = el + 2
  rescue => e
    raise StandardError.new()
  end
end

```


Additional variants to consider:

- behaviour of nested begin/rescue's
- how to raise an error/exception from inside a nested begin/rescue

E.g. say you're already inside a begin/rescue and you want another. You probably don't want to accidentally break out of the *entire* (i.e. both) begin/rescue's if there's an error in the inner one. Let's see what ruby actually does:


```ruby

(1..3).each do |num|
  begin
    puts "outer loop: #{num.to_s}"
    # Stuff from simpler example above
    arr = [1, 2, "cats and dogs", 4]
    arr.each_with_index do |el, i|
      begin
        arr[i] = el + 2
      rescue => e
        $stderr.puts "inner error: #{e.message}"
      end
    end
  rescue => e
    $stderr.puts "outer error: #{e.message}"
  end
end

# outer loop: 1
# inner error: no implicit conversion of Integer into String
# outer loop: 2
# inner error: no implicit conversion of Integer into String
# outer loop: 3
# inner error: no implicit conversion of Integer into String

```

Could probably have come up with a simpler example, but the above demonstrates that the outer loop continues to run despite the inner loop hitting an error and being rescued









### Tap method

Tap allows you to do something with an object without modifying its value or disrupting a chain of method calls. That is, it yields the object on which it's called to a block. Then it returns the original object, regardless of what the block does. It can also produce more expressive code [example here](https://stackoverflow.com/a/17493604/5783745)

```ruby
'hello'.tap { |string| puts string.upcase }
# Outputs: HELLO
# Returns: 'hello'


[1, 2, 3, 4, 5].select { |num| num.even? }
    .tap { |nums| puts "Evens: #{nums}" }
    .map { |num| num * 2 }
# Outputs: Evens: [2, 4]
# Returns: [4, 8]

```



# Class methods vs Instance methods


Define a class method:


From [here](https://www.rubyfleebie.com/2007/04/09/understanding-class-methods-in-ruby/):

> Once you understand that classes are objects, this use of the self variable to define a class method finally makes sense.




```rb

# Create some new class
class Test
end



# Define a class method (the preferred way by RoR link)

class Test
  def self.hello1
    "Hello 1!"
  end
end

# Test.hello1
# => "Hello 1!"



# Another way to define a class method. Okay, but not the preferred way.

class Test
  def Test.hello2
    "Hello 2!"
  end
end

# Test.hello2
# => "Hello 2!"



# A third way to define a class method
# From: https://railsware.com/blog/better-ruby-choosing-convention-for-class-methods-definition/
# Also okay, but not the preferred way.  

class Test
  class << self

    def hello3
      "Hello 3!"
    end

  end
end
```

Define an instance method:


```rb
# Define an instance method

class Test
  def hello4
    "Hello 4!"
  end
end

# test = Test.new
# test.hello4()

# The same way of defining an instance method, but one which uses 'self'

class Test
  def palindrome?
    self == self.reverse?
  end  
end  


# Note that the method above will error if run because the .reverse method is not defined for class Test (only for class String).
# I.e. this won't work:

# test = Test.new
# test.palindrome? 
# NoMethodError (undefined method `reverse' for #<Test:0x00007fb2ef9d9e38>)

# But if we define the same method on the string class:


class String
  def palindrome?
    self == self.reverse
  end
end

# "hi".palindrome?
# => false
# "hih".palindrome?
# => true


```


- After defining a **class** method, you can see that it exists like so: `Thing.methods(:your_class_method)` (you can add `.source_location` to get result if it exists and an obvious error if it doesn't). 
- After defining an **instance** method, you can check it like so `Thing.new.methods(:your_instance_method)` (add `.source_location` as before). Note that looking up a class method on an instance will return nothing/error, and looking up an instance method on a class will also return nothing/error! 
- These are good ways of understanding that class methods really are available to the class (only), and instance methods only available to the instance (only).
  - This is obvious once you know, but those from a functional programming background may erroneously assume that class methods are available to instances and instance methods available to classes, but that's not the case. 
- A good practical example of a class method is something like `purge_banned_users` or some method that would have to run across all instances of a class. Whereas a good example of an instance method is something that would only be run on one instance (e.g. one user) at a time. 




### Storing data in a class with attr_accessor

Example from [ruby on rails berkeley](https://www.youtube.com/watch?v=LuuKDyUYFTU&t=10m45s) course:


```
class Foo

# constructor
  def initialize(args={})
    @bar = args[:bar]
  end

  # getter
  def bar
    @bar
  end

  # setter
  def bar=(newval)
    @bar = newval
  end

end
```

The same can be achieved with just:

```
class Autofoo
  attr_accessor :bar
end
```

These allow you to do things like:


```
a = Foo.new
a.bar
# => nil

# Set the value
a.bar = 2

# Get the value
a.bar
# => 2
```



### Extending classes and the `Object` class



You can extend a class like so:


```rb

class User
  def new_thing
   ...
  end
end
```



Note that all classes inherit from the `Object` class, so anything you place there will be available in other classes. For example, here we make `somemethod` available to the `String` class, via the `Object` class. 


```rb
class Object
  def somemethod
    self + "hi"
  end
end
"nn".somemethod
# => "nnhi" 
```


### Handy note on superclass and ancestors


To get an object's class

```ruby

user = User.first
user.class

# Get it's superclass

user.class.superclass
# ApplicationRecord(abstract)

# View all its ancestors

user.class.ancestors
# Devise::Models::Trackable,
# Devise::Models::Confirmable,
# Devise::Models::Validatable,
# Devise::Models::Registerable,
# Devise::Models::Recoverable,
# Devise::Models::Rememberable,
# Devise::Models::DatabaseAuthenticatable,
# Devise::Models::Authenticatable,
# ActiveSupport::Deprecation::DeprecatedConstantAccessor,
# Devise::Orm::DirtyTrackingNewMethods,
# Devise::Orm,
# User::GeneratedAssociationMethods,
# User::GeneratedAttributeMethods,
# ApplicationRecord(abstract),
# ApplicationRecord::GeneratedAssociationMethods,
# ApplicationRecord::GeneratedAttributeMethods,
# ActionText::Encryption,
# ActiveRecord::Base,
# Turbo::Broadcastable,
# ActionText::Attribute,
# ActiveStorage::Reflection::ActiveRecordExtensions,
# ActiveStorage::Attached::Model,
# MoneyRails::ActiveRecord::Monetizable,
# GlobalID::Identification,
# ActiveStorageValidations,
# PhonyRails::Extension,
# CanCan::ModelAdditions,
# ActiveRecord::Encryption::EncryptableRecord,
# ActiveRecord::Suppressor,
# ActiveRecord::SignedId,
# ActiveRecord::SecureToken,
# ActiveRecord::Store,
# ActiveRecord::Serialization,
# ActiveModel::Serializers::JSON,
# ActiveModel::Serialization,
# ActiveRecord::Reflection,
# ActiveRecord::NoTouching,
# ActiveRecord::TouchLater,
# ActiveRecord::Transactions,
# ActiveRecord::NestedAttributes,
# ActiveRecord::AutosaveAssociation,
# ActiveModel::SecurePassword,
# ActiveRecord::Associations,
# ActiveRecord::Timestamp,
# ActiveModel::Validations::Callbacks,
# ActiveRecord::Callbacks,
# ActiveRecord::AttributeMethods::Serialization,
# ActiveRecord::AttributeMethods::Dirty,
# ActiveModel::Dirty,
# ActiveRecord::AttributeMethods::TimeZoneConversion,
# ActiveRecord::AttributeMethods::PrimaryKey,
# ActiveRecord::AttributeMethods::Query,
# ActiveRecord::AttributeMethods::BeforeTypeCast,
# ActiveRecord::AttributeMethods::Write,
# ActiveRecord::AttributeMethods::Read,
# ActiveRecord::Base::GeneratedAssociationMethods,
# ActiveRecord::Base::GeneratedAttributeMethods,
# ActiveRecord::AttributeMethods,
# ActiveModel::AttributeMethods,
# ActiveRecord::Locking::Pessimistic,
# ActiveRecord::Locking::Optimistic,
# ActiveRecord::Attributes,
# ActiveRecord::CounterCache,
# ActiveRecord::Validations,
# ActiveModel::Validations::HelperMethods,
# ActiveSupport::Callbacks,
# ActiveModel::Validations,
# ActiveRecord::Integration,
# ActiveModel::Conversion,
# ActiveRecord::AttributeAssignment,
# ActiveModel::AttributeAssignment,
# ActiveModel::ForbiddenAttributesProtection,
# ActiveRecord::Sanitization,
# ActiveRecord::Scoping::Named,
# ActiveRecord::Scoping::Default,
# ActiveRecord::Scoping,
# ActiveRecord::Inheritance,
# ActiveRecord::ModelSchema,
# ActiveRecord::ReadonlyAttributes,
# ActiveRecord::Persistence,
# ActiveRecord::Core,
# ActiveSupport::Dependencies::RequireDependency,
# ActiveSupport::ToJsonWithActiveSupportEncoder,
# Object,
# PP::ObjectMixin,
# ActiveSupport::Tryable,
# JSON::Ext::Generator::GeneratorMethods::Object,
# DEBUGGER__::TrapInterceptor,
# Kernel,
# BasicObject]

```





### How ruby handles hashes as arguments 


```rb
def foo(first={}, second={})
  puts "First hash:"
  first.each do |k, v|
    puts k.to_s + ": " + v.to_s 
  end
  puts "Second hash:"
  second.each do |k, v|
    puts k.to_s + ": " + v.to_s
  end
end



# A method that accepts two hashes assumes any 'loose' key value pairs belong to the first hash

foo(hi: 2, there: 4)
# First hash:
# hi: 2
# there: 4
# Second hash:

foo({hi: 2, there: 4}, {})
# First hash:
# hi: 2
# there: 4
# Second hash:

foo({hi: 2, there: 4}, {other: 7})
# First hash:
# hi: 2
# there: 4
# Second hash:
# other: 7

foo({hi: 2, there: 4}, other: 7)
# First hash:
# hi: 2
# there: 4
# Second hash:
# other: 7

foo({hi: 2, there: 4}, other: 7, more: 9)
# First hash:
# hi: 2
# there: 4
# Second hash:
# other: 7
# more: 9
```

Lessons:

- when a method accepts a hash, you don't need to place the {} around its key value pairs as you would normally when making a hash. 
- When a method accepts multiple hashes, it will assume arguments without {} around them are all from the **first** hash
  - If the first hash has {} around it and there's more key/value pair(s) without {} around it/them, it will be assumed those arguments are from the **second** hash

Yeah, that's not intuitive, but it makes sense when you're aware of it. Methods like [button_to](https://apidock.com/rails/v5.2.3/ActionView/Helpers/UrlHelper/button_to) will then make sense. 

- Consider what would happen if a function took two hashes as arguments and the {} were omitted, then it would be ambiguous as to which hash each key/value pair belonged to. See [here](https://www.youtube.com/watch?v=LuuKDyUYFTU&t=5m50s): 

> If you have a function that can take multiple arguments each of which is a hash, then it becomes confusing

Solution: use {} in that case to denote the start and end of each hash. 


# Super

`super` (and `super()`) are keywords (not methods). 

A really basic example: 

```ruby

class Test1 
  def hello
    puts "hello"
  end
end

Test1.new.hello
# hello

class Test2 < Test1
end

Test2.new.hello
# hello

class Test2 
  def hello
    super
  end
end

Test2.new.hello
# hello

class Test2
  def hello
    super
    puts "yo"
  end
end
Test2.new.hello
# hello
# yo

```



An [example](https://medium.com/rubycademy/the-super-keyword-a75b67f46f05) of when the child method accepts an argument, but the parent method does not:


```ruby

class Parent
  def say
    p "I'm the parent"
  end
end

class Child < Parent
  def say(message)
    super()
  end
end

Child.new.say('Hi!') # => "I'm the parent"
```

So the point here is that when using the `super()` keyword (with `()`), then the argument *won't* get passed up to the parent method. I'm not too sure where this would be useful tbh (a [quick search](https://github.com/search?p=5&q=%22super%22+language%3Aruby&type=Code) on GitHub shows the first case of super *with* the parentheses appears on page 5 of the search results, around the 50th result). 



`super` with blocks works how you'd expect ([example](https://medium.com/rubycademy/the-super-keyword-a75b67f46f05)):


```ruby

class Parent
  def say
    yield
  end
end

class Child < Parent
  def say
    super
  end
end

Child.new.say { p 'Hi!' }
# "Hi!"
# => "Hi!"

```



# Regular expressions in ruby 

From Agile Web Development in Rails:

> A regular expression lets you specify a *pattern* of characters to be matched in a string. In Ruby, you typically create a regular epression by writing `/pattern/` or `%r{pattern}`. (p52). Programs typically use the *match operator* `=~` to test strings against regular expressions. 


Some examples from [idiomatic ruby slides](http://cbcg.net/talks/rubyidioms/) (slide 17). Reminder that `sub` subs the *first* ocurrance, and `gsub` subs *all* ocurrences. 

```ruby
"hello".sub /o/, ' no'
# hell no

def no_vowels(str)
  str.gsub /[aeiou]/, "!"
end

no_vowels "Hello, world!"
# "H!ll!, w!rld!"

```


Group matching:


```ruby

def obfuscate_cc(num)
  if num =~ /\d\d\d\d-\d\d\d\d-\d\d\d\d-(\d\d\d\d)/
    "XXXX-XXXX-XXXX-#{$1}"
  else
    "Invalid credit card number"
  end
end

puts obfuscate_cc("1234-5678-9012-3456")
# XXXX-XXXX-XXXX-3456

```






# Splat

Using splat in a method creates an array of all the arguments:

```ruby
def hi(*names)
  names.map{ |name| puts "hi #{name}"}
end

hi("john", "susan", "jo")
# hi john
# hi susan
# hi jo
```

Using splat in assignment 

```ruby
arr = ["mouse", "cat", "dog"]
pest, *pets = arr

pest
# "mouse"

pets
# ["cat", "dog"]
```




# Keyword arguments and default arguments

There are some great examples of these in my poodr notes. TL;DR 

- Use keyword arguments \~80% of the time (they make code more loosely coupled, since argument order ceases to matter), so keyword arguments > positional arguments 80% of the time. 
- Be careful of a potential 'gotcha' when you think you're dealing with a method that accepts keyword arguments. Since they're submitted like hashes, a method that *doesn't* accept keyword arguments but receives one will think it's a hash and might run without error, which could be dangerous! 
- Interesting case with rails `render` method [here](https://stackoverflow.com/a/75586745/5783745)

**Keyword arguments**

```ruby

# No keyword arguments
def hotdog1(amount)
  puts "#{amount} hotdogs please!"
end

# Now it will require the keyword argument
def hotdog2(amount:)
  puts "#{amount} hotdogs please!"
end

hotdog2(5) # Expecting keyword argument but doesn't receive one: errors
hotdog2(amount: 5) # Expecting keyword argument and receives one: works

```


**Default arguments**


Default parameters without keyword arguments

```ruby

def hotdog(amount = 4)
  puts "Hi, I'd like #{amount} hotdogs, please!"
end

hotdog # workds
hotdog(99) # works
hotdog(amount: 55) # DANGER - it doesn't error but it's not what we want! 
```

Default paramters with keyword arguments

```ruby
def hotdog(amount: 5)
  puts "Hi, I'd like #{amount} hotdogs, please!"
end

hotdog # works
hotdog(amount: 7) # works
hotdog(7) # errors

```

**A potential gotcha to be aware of**

When a method doesn't expect a keyword argument but you supply it with one, it **may not throw an error**, but instead interpret what you gave it as a hash. So be wary!

```ruby

hotdog1(amount: 7)
# {:amount=>7} hotdogs please!

```



# Blocks

Resources:
- https://medium.com/podiihq/ruby-blocks-procs-and-lambdas-bb6233f68843
- Agile Web Development in Ruby On Rails (DHH, Sam Ruby et al)
- Good explanation of {} and do on [stack overflow](https://stackoverflow.com/questions/5587264/do-end-vs-curly-braces-for-blocks-in-ruby)
- [Enumerable methods](https://www.youtube.com/watch?v=nZNfSQKC-Yk&t=14m) (.each, .map, .inject)
  - These are methods applied to collection objects that can do a lot of different things (iterating, sorting, filtering, querying, fetching, and more). See [here](https://ruby-doc.org/core-3.1.2/Enumerable.html) for a list of them and what they do!
  - Awesome quick and dirty list of each enumerable method and what it does [here](https://ruby-doc.org/core-3.1.2/Enumerable.html).

[From here](https://medium.com/@noordean/understanding-ruby-blocks-3a45d16891f1):

> Ruby blocks are anonymous functions that can be passed into methods. Blocks are enclosed in a do-end statement or curly braces {}. do-end is usually used for blocks that span through multiple lines while {} is used for single line blocks. Blocks can have arguments which should be defined between two pipe | characters.


From [idiomatic ruby](http://cbcg.net/talks/rubyidioms/) (slide 21):

> Blocks make it easy to implement iterators, callbacks, transactions etc. 

From [here](http://www.vikingcodeschool.com/falling-in-love-with-ruby/blocks-procs-and-lambdas):

> They're often called "anonymous functions" because they have no name but behave much like functions.


```ruby 

# A block (inline)
[1, 2, 3].each { |n| puts n }

# Also a block (multi-line)
[1, 2, 3].each do |n|
  puts n
end
```

> In this example, the block’s argument is **n** and the block’s body is **puts n**. The block is passed to the **.each** method of an **array** object. So if you have used the each method before, you’ve definitely used Ruby blocks.


**Yielding a block** (based on [this](https://medium.com/podiihq/ruby-blocks-procs-and-lambdas-bb6233f68843))

```ruby
def hi
  puts "Hi there"
  yield
  puts "goodbye"
end

hi do |content|
  puts "Hope you're having a great day!"
end

# Hi there
# Hope you're having a great day!
# goodbye
```

So literally all yield does is run the code supplied in the block. 

Another example (from [here](https://www.youtube.com/watch?v=UCB57Npj9U0#t=31m14s)):

```
def twice
  yield
  yield
end

twice { puts "Get your shoes on..." }

# Get your shoes on...
# Get your shoes on...

# or

twice do 
  puts "Get your shoes on..."
end

# Get your shoes on...
# Get your shoes on...


```

**Passing parameters to yield** (based on [this](https://medium.com/podiihq/ruby-blocks-procs-and-lambdas-bb6233f68843))


```ruby

def hi
  yield 2
  yield 3
end

hi { |parameter| puts "My number is #{parameter}"}

# My number is 2
# My number is 3

```


Another example (from [here](https://medium.com/@noordean/understanding-ruby-blocks-3a45d16891f1), this time defining behaviour when a block is optional:

```ruby

def say_my_age
  if block_given?
    yield
  else
    "You didn't give me your age"
  end
end

say_my_age
# "You didn't give me your age"
say_my_age { 30 }
# 30 

```



Another example (based on [here](https://medium.com/@noordean/understanding-ruby-blocks-3a45d16891f1)): We can explicitly pass in a block as method parameter and invoke the block right inside our method (using the `.call` method). Note: The `&` denotes that the parameter is a block. 


```ruby

def say_age(&my_block)
  my_block.call # Gives same result as yield
end

say_age { puts 22 }
# 22

# or

say_age do 
  22
end
# 22

```


From [here](https://medium.com/@noordean/understanding-ruby-blocks-3a45d16891f1):

> The `instance_exec` and `instance_eval` Methods: Blocks can also be invoked by using these two methods, and they come in handy in building Ruby DSLs such as FactoryBot when combined with some Ruby metaprogramming techniques such as `method_missing`, `define_method`, etc.



Another example from slide 22 [here](http://cbcg.net/talks/rubyidioms/). This example shows how to pass a parameter and a block to a method other examples [here](http://www.vikingcodeschool.com/falling-in-love-with-ruby/blocks-procs-and-lambdas): 

```ruby

def fibonacci(max)
  x, y = 1, 1
  while x <= max
    yield x if block_given? 
    x, y = y, x + y
  end
end

fibonacci(30) { |x| print x.to_s + " " }
# 1 1 2 3 5 8 13 21

y = 0
fibonacci(30) { |x| y += x }
p y 
# 54

```

Just one more example of a block, use of &block, block_given? and yield (I made this one up)

```rb

def hi(*args)
  args.each do |arg|
    puts arg.to_s
  end
end

hi("a", "b")
# a
# b

def hii(*args, &block)
  args.each do |arg|
    puts arg
  end
  if block_given?
    yield
  end
end

# Call without a block
hii("a", "b")

# a
# b

# Call with a block
hii("a", "b") { puts "boom!" }
# a
# b
# boom!

# or same thing using 'do' block

hii("a", "b") do
  puts "boom!"
end


# define a method with one or more block and block parameters

def hi3(a, b, p, q, &block)
 puts a
 if block_given?
   yield p, q
 end
 puts b
end

# Call it without a block


hi3("a", "b", "p", "q")

# Call it with a block
hi3("a", "b", "p", "q") do |i, j|
  puts "this is the value of p: #{i}"
  puts "and here's q!.. #{j}"
end

# Reminder, if we want optional arguments to a method in ruby, simply make them p = nil and q = nil etc.
# Redfine above method accordingly
def hi4(a, b, p=nil, q=nil, &block)
 puts a
 if block_given?
   yield p, q
 end
 puts b
end

# Now calling without a block and omitting p and q works (attempting to omit p and q without making them optional arguments would result in an error).
hi4("a", "b")

```



# Procs

From [here](https://medium.com/podiihq/ruby-blocks-procs-and-lambdas-bb6233f68843):

> Ruby introduces procs so that we are able to pass blocks around. 

> Proc objects are blocks of code that have been bound to a set of local variables. Once bound, the code may be called in different contexts and still access those variables.

From me: basically it's storing code as a variable. Nothing more than that. E.g. 

```rb
square = Proc.new { |x| x ** 2 }
square.call(5)
# 25
```

It's that simple. To compare to what I already know, R, and noting that R can store a function as a first class object without any rigmorale:

```r
square <- function(x) {
  x ^ 2
}

square(5)
# 25
```

```r
outer_funct <- function(dosomething, number) {
  dosomething(number)
}

outer_funct(square, 5)
```

TL;DR R can already do the work of Procs. R calls the *outer* function a 'functional' (a function which accepts a function). Whereas in ruby you can't pass a method/function to another method/function, so instead you create a Proc if you want to do that. 

Here's a great example of using ruby procs (from Jason's book on testing):

```ruby
def perform_operation_on(number, operation)
  operation.call(number)
end

square = Proc.new { |x| x**2 }
double = Proc.new { |x| x * 2 }

puts perform_operation_on(5, square)
# 25
puts perform_operation_on(5, double)
# 10
```


**2 ways to define a proc**

```ruby
myproc = Proc.new { |num| puts num**3 }

myproc = proc { |num| puts num**3} # the 'proc' method is simply an alias for Proc.new

[1,2,3,4].each(&myproc)
# 1
# 8
# 27
# 64
```




# Lambdas 

- A great (and really easy to understand) example of lambdas is in rails scopes. 

From [here](https://scoutapm.com/blog/how-to-use-lambdas-in-ruby): 

> Ruby lambdas allow you to encapsulate logic and data in an eminently portable variable.


```ruby
lamb = lambda {|n| puts 'I am a lambda' } # A lambda defined using the lambda method
lamb = -> (n) { puts 'I am a stuby lambda' } # A "stuby lambda"
```


So what's the difference between a proc and a lambda? (from [here](https://medium.com/podiihq/ruby-blocks-procs-and-lambdas-bb6233f68843))

- Procs don’t care about the correct number of arguments, while lambdas will raise an exception.
- Return and break behaves differently in procs and lambdas
- Next behaves same way in both procs and lambdas




### Some nice simple examples of procs and lambdas from codecademy

- My words: procs and lambdas are both just chunks of code that can be called at some future time


- From [here](https://www.codecademy.com/learn/learn-ruby/modules/learn-ruby-blocks-procs-and-lambdas-u/cheatsheet): 

> In Ruby, a proc and a lambda can be called directly using the `.call` method.


```rb

test = Proc.new { puts "I am the proc method!" }
lambda_test = lambda { puts "I am the lambda method!"}

proc_test.call # => I am the proc method!
lambda_test.call # => I am the lambda method!
```

The difference between a proc and a lambda:

> In Ruby, a lambda is an object similar to a proc. Unlike a proc, a lambda requires a specific number of arguments passed to it, and it returns to its calling method rather than returning immediately.


```rb
def proc_demo_method
  proc_demo = Proc.new { return "Only I print!" }
  proc_demo.call
  "But what about me?" # Never reached
end

puts proc_demo_method 
# Output 
# Only I print!

# (Notice that the proc breaks out of the method when it returns the value.)

def lambda_demo_method
  lambda_demo = lambda { return "Will I print?" }
  lambda_demo.call
  "Sorry - it's me that's printed."
end

puts lambda_demo_method
# Output
# Sorry - it's me that's printed.

# (Notice that the lambda returns back to the method in order to complete it.)

```






















# Modules

From [ruby docs](https://ruby-doc.org/core-2.4.2/Module.html#method-i-instance_methods): 

> A module is a collection of methods and constants. The methods in a module may be instance methods or module methods. Instance methods appear as methods in a class when the module is included, module methods do not.
- A module is a great way of including the same methods/constants in mulitple classes whilst keeping code DRY (since you can simply write the module, then import it in any class you want it in, then the methods/constants will be considered part of whatever class(s) imported the module).

```ruby
module Mod
  include Math
  CONST = 1
  def meth
    #  ...
  end
end
Mod.class              #=> Module
Mod.constants          #=> [:CONST, :PI, :E]
Mod.instance_methods   #=> [:meth]
```

- A good example of a module is the helper file in a rails app. E.g. the application_helper.rb:

```ruby
module ApplicationHelper
end
``` 

- `include` the module like so

```ruby
include CurrenciesHelper
include HomeHelper
# etc 
```

Note that it's common to include one or more modules inside a class. Note that rails automatically includes the helper file of the same name in that class without you having to do anything. 

From [Derek Banas](https://www.youtube.com/watch?v=Dji9ALCgfpM&t=34m25s):

> the most common reason you're going to use these is to add functionality to a class because we're only going to be able to inherit one class when we're creating a class, but we will be able to inherit mulitple modules.


A note on the enumerables module (from [Derek Banas](https://www.youtube.com/watch?v=Dji9ALCgfpM&t=41m20s)):

> a class that includes the Enummerable module is gonna gain collection capabilities sort of like we saw with arrays and hashes

e.g. 

```ruby
class Menu
  include Enumerable

  def my_each 
    yield "pizza"
    yield "coke"
    yield "fries"
  end
end

Menu.new.my_each do |item|
  puts item
end
# pizza
# coke
# fries

```

- Note that the ruby language has many modules as part of its standard library, for example the Math module. And a reminder tha to use methods from a module you can first load the module with include (see example above), or you can just prepend the module name and :: and then the metho, like so:

```
Math::PI
=> 3.141592653589793 
```	


- Random example of (what I think is) a module [here](https://stackoverflow.com/a/75559132/5783745)


```rb
ActiveRecord::Migration.drop_table(:products)
```

Which I found by looking through the ActiveRecord source code [here](https://github.com/rails/rails/blob/main/activerecord/lib/active_record/migration/command_recorder.rb). (note that I couldn't actually find `def drop_table` so perhaps it's defined elsewhere, or defined via meta programming - not too sure tbh.




# Ruby Gems


[How to create one](https://www.youtube.com/watch?v=NGXp6_-nc4s&t=11m43s) - simply run:

```sh
bundle gem rubyconf_palindrome # creates gem
# cd into gem
bundle exec rake test # Runs tests
```

Side note: incidentally, [this](https://www.youtube.com/watch?v=NGXp6_-nc4s&t=12m) is an excellent \~10 minute example of
test driven development. 











# Pry - Using `pry` to debug, view docs, and view source (for both irb and rails c)

- Rubyconf 2019 [video on pry and debugging](https://www.youtube.com/watch?v=GwgF8GcynV0) by Jim Weirich
  - `ls` to view objects available to you
  - `cd ../` etc to navigate 
  - `$` to show the current source of where your `binding.pry` is (or wherever you've cd'd into)
  - `$ Module` or `$ method` to see other stuff's source
    - Great [examples here](https://stackoverflow.com/a/7056610/5783745) 
- The pry docs are great (just the [readme itself](https://github.com/pry/pry#navigating-around-state) contains a lot of beginner and advanced functionality). 

Note that the run pry in rails, you add `binding.pry` where you want the code execution to pause. You can then jump into the console and run whatever code you like. 

To run the pry console in irb or rails console, you do the following:

```
gem install pry
gem install pry-doc
```

then in terminal run `pry` and it starts. OR run `irb` or `rails c`

```ruby
require 'pry'
require 'pry-doc'

# Don't forget to run 'pry' command to enter pry
pry 
```


### How to clean up the ruby irb or rails console a bit


Situation: say I run 

```ruby

Conversation.all.each do |c|
  puts "convo: #{c.id.to_s} messages: #{c.messages.count.to_s}"
end

```

That will puts the required line but it will also be cluttered with: 

1. the sql query(ies) e.g. (this for every query that's run, e.g. potentially a lot if running some sql in a .each enumeration):


```
convo: 15 messages: 2
  Message Count (0.0ms)  SELECT COUNT(*) FROM "messages" WHERE "messages"."conversation_id" = ?  [["conversation_id", 16]]
```

2. the return objects (also a lot), e.g.

```
 #<Conversation:0x000000010614a008
  id: 9,
  title: "Howdy",
  created_at: Wed, 15 May 2024 01:28:54.201524000 UTC +00:00,
  updated_at: Wed, 15 May 2024 01:28:54.201524000 UTC +00:00>,
```



To turn off the sql queries:

```rb
ActiveRecord::Base.logger.level = Logger::WARN

# Can reenable with 
ActiveRecord::Base.logger.level = Logger::DEBUG

```

And can get rid of those return objects by appending `; nil`

```rb
Conversation.all.each do |c|
  puts "convo: #{c.id.to_s} messages: #{c.messages.count.to_s}"
end; nil
```

To [turn off the pager](https://stackoverflow.com/a/78630771/5783745) in the rails console:

```
IRB.conf[:USE_PAGER]

# View IRB settings with
IRB.conf
```


**To look up documentation for a method**

Use `?` or `show-source` methods (I'm not sure of the difference, but `?` appears to give a little more info)


```sh
? File.link # Grabs docs for File.link method

# NOTE: if this doesn't work, don't forget to require 'pry-doc'


# Note: ? and show-source appear to do the same thing:
? Array#pop 
show-source Array#pop -d
# Second example is from here: https://www.reddit.com/r/ruby/comments/m11lms/how_to_fix_invoke_the_geminstall_prydoc_pry/

```

Another great way to look up source code is to use `ri` in *the command line* (not in irb/rails console). E.g.:

```sh
ri File.link
ri inject
```

- Note that `ri` won't give documentation on ruby keywords (nor will a lot of other ruby documentation sites). Example `ri and` gives (for me) docs for ActiveRecord, capybara, and rspec's `and` methods, but not the ruby `and` keyword. 
  - [This](https://rubystyle.guide/#and-or-flow) site does give a little info about ruby keywords.
  - [This](https://docs.ruby-lang.org/en/3.2/keywords_rdoc.html) is the best page I could find with info about ruby keywords (although there's not a *lot* of info there).




**To look up source code for a method**

```ruby

$ File.link
# NOTE: if this doesn't work, don't forget to require 'pry-doc'

# Another example (hese do the same thing): 
$ Rails.configuration
show-source Rails.configuration

```


# How to find documentation for the ruby language (and rails)


- [devdocs](https://devdocs.io/) website is great, and it can be installed on localhost for offline access
  - See instructions in the [github repo](https://github.com/freeCodeCamp/devdocs) for how to get up and running locally in a few minutes
    - Follow the [quick start](https://github.com/freeCodeCamp/devdocs?tab=readme-ov-file#quick-start) instructions, and start the localhost with `bundle exec rackup` (and visit http://localhost:9292). 
    - To show available docs `thor docs:list` and to download a specific one e.g. `thor docs:download ruby@3.1` (note that you have to 'enable' it in the browser once downloaded)


- Another way is using `ri`
  - Run `gem rdoc --all` to install docs for installed gems
  - Install if you haven't already: `gem install rubygems-server`
  - Start it with: `gem server`
  - Go to: http://0.0.0.0:8808

- Another way is to download the rails guides: https://guides.rubyonrails.org/
  - I think this is only possible via cloning the rails repo and I think they're also on kindle
  - When cloning rails, the guides are in rails/guides/source
  - Note that if wishing to view these offline, grip doesn't work (it needs to make network calls for some reason)








# Singletons

**Singletons TL;DR** Singletons are good to know about, but except for special cases, avoid using them. 

- [Medium article](https://medium.com/rubyinside/class-methods-in-ruby-a-thorough-review-and-why-i-define-them-using-class-self-af677ede9596)

From [here](https://dev.to/samuelfaure/explaining-ruby-s-singleton-class-eigenclass-to-confused-beginners-cep): 

> The Singleton pattern is simply an object-oriented programming pattern where you make sure to have 1 and only 1 instance of some class.

- Might also be called an [Eigenclass](https://en.wiktionary.org/wiki/eigenclass)


From [here](https://medium.com/rubyinside/class-methods-in-ruby-a-thorough-review-and-why-i-define-them-using-class-self-af677ede9596):

> In general, Ruby methods are stored in classes while data is stored in objects, which are instances of classes. 


### A quick example of a singleton

```ruby
require 'singleton'

class Shop
  include Singleton
end
```

Now we can't create a new shop instance in the usual way:

```ruby
Shop.new
NoMethodError (private method `new' called for Shop:Class)
```


but instead we can ask `Shop` for its one and only instance, like so:

```ruby

Shop.instance
```








# Ruby language capabilities and quirks

- [Single quotes vs Double quotes](https://stackoverflow.com/questions/6395288/double-vs-single-quotes#comment88736030_6395332)? ANS: just use double quotes all the time (they allow string interpolation, and there's no performance impact over single quotes). 



Assign multiple variables like this: `a, b = 2, 3`

It also works with splat `*` e.g. 

```ruby
arr = ['mouse', 'cat', 'dog']
pest, *pets = arr

pest
# "mouse"

pets
# ["cat", "dog"]
```

<hr>


`.self` can [sometimes be ommitted](https://www.youtube.com/watch?v=NGXp6_-nc4s&t=19m05s), since without it the default is the current object. For example, this can be re-written:

```ruby

class String
  def palindrome?
    self == self.reverse
  end
end
```

as this

```ruby

class String
  def palindrome?
    self == reverse
  end
end
```


<hr>

> When calling a method, ruby will first look within the class, then the module, then `method_missing` , then at any ancestor classes
  - TODO `method_missing` example here


<hr> 

The way to remove / delete / destroy an object in ruby? Surprise: there isn't one! The best you can do is [set it to `nil`](https://stackoverflow.com/a/19530391/5783745). 

However, you can use the pry console (by `gem install pry`, then `require 'pry'`, then simply `pry`), and use `reset` to remove all objects. Another way to enter the pry console from terminal simply type `pry` and boom, you're in!




<hr>

How to add an instance variable to a class, and access it (example based on [here](https://ruby-doc.org/core-3.1.0/Object.html#method-i-remove_instance_variable)) (also demonstrates `attr_reader` and `attr_writer`):

```ruby

class Dummy
  def initialize
    @var = 999
  end
end
Dummy.new.var
# NoMethodError (undefined method `var' for #<Dummy:0x00007fad5905de40 @var=999>)

# So give it an attr_reader

class Dummy2
  attr_reader :var
  def initialize
    @var = 9999
  end
end
Dummy2.new.var
# => 9999


# Note that
a = Dummy2.new
a.var 
# 9999
a.var = 80
# NoMethodError (undefined method `var=' for #<Dummy2:0x00007fad78815a88 @var=9999>)
a.update(var: 80)
# NoMethodError (undefined method `update' for #<Dummy2:0x00007fad78815a88 @var=9999>)

# So we need attr_writer
class Dummy3
  attr_reader :var
  attr_writer :var
  def initialize 
    @var = 99999
  end
end

a = Dummy3.new
a.var
# => 99999
a.var = 80
a.var
# => 80

```

- Note (from [here](https://medium.com/@alicespyglass/why-attr-reader-attr-writer-are-windows-into-object-orientated-programming-and-how-they-work-9bb67014af82)) that while `attr_reader`, and `attr_writer` can be used to determine which bits of data for a class can be seen and alterned, `public`, and `private` methods for a class detemine whether the methods can be accessed on that class. (note that we can probably add `protected` to that list)




<hr>

Note that removing / deleting / destroying objects doesn't seem to be simple as with R, I'm not exactly sure why there aren't simple ways of deleting things (perhaps it's just not that important, or because it's safer to make the dev build those features themselves). See more [here](https://stackoverflow.com/a/2012125)


<hr>

Note that while hashes can have keys that are symbols or strings, that doesn't mean they can be accessed either way. That is, if the key is a string, use a string to access it; similarly, if they key is a symbol, you must use a symbol to acccess it. From community: "most of the time you'll want symbol keys". Note that you [must use hash rocket](https://stackoverflow.com/a/70726247/5783745) notation when defining a hash with keys of class String. 

Easy example (from [here](https://stackoverflow.com/a/16194278/5783745)):

```ruby
h = {:name => 'Charles', "name" => 'Something else'}
h[:name] #=> 'Charles'
h["name"] #=> 'Something else'
```

<hr>


**Closures** (from slide 24 [here](http://cbcg.net/talks/rubyidioms/)). Note that rorlink thought it was unclear what exactly this code was trying to achieve/demonstrate:

```ruby
class ButtonController
  def initialize(label, &action)
    @label = label
    @action = action
  end
  def press
    @action.call @label
  end
end

ButtonController.new("Start") { thread.start }
ButtonController.new("Pause") { thread.pause }


```

- .start and .pause work even when thread goes out of scope
- closure's environment is a reference, not a copy
- They're most commonly created with blocks or lambda: 

```ruby
def mkcounter
  lambda { a += 1; puts "#{a}" }
end
```

The lambda creates a `proc` object with associated block. 


<hr>

`method_missing` will capture any method call for which the receiver has no predefined method

```ruby
class Roman
  def romanToInt(str)
    # ...
  end
  def method_missing(methId)
    str = methId.id2name
    romanToInt str 
  end
end

r = Roman.new
r.iv #=> 4
r.xxiii #=> 23
r.mm #=> 2000

```


<hr>

**Continuations** ([here](http://cbcg.net/talks/rubyidioms/) - slide 29) are the saved state of a program.
- Calling a continuation brings execution back to right after it was created
- `callcc` (["call with current continuation"](https://stackoverflow.com/questions/tagged/callcc)) takes a block and passes a `Continuation` object to it
- Often described as a "go to with arguments".
- When asked why he put in continuations and not macros, Matz said "the people who'd make an awful mess with macros wouldn't even dare to *touch* continuations". 
- Good use case [here](https://www.honeybadger.io/blog/how-to-try-again-when-exceptions-happen-in-ruby/)
  - Brilliant examples of case when and case in [here](https://www.akshaykhot.com/ruby-switch-statement/)
- Note that randomly paul graham says continuations may make a comeback in his 'Dynamic languages' talk [here](https://www.youtube.com/watch?v=agw-wlHGi0E&t=36m30s)
<hr>

Note that methods like `<<` can still be called with the `.` syntax, like so:

```ruby
arr = [1,2,3]

arr << 4 # standard way to call << 

lol.<<(5) # with . syntax
```

<hr>

A way to store data in a method


```ruby

def foo
  @foo ||= [1,2,3]
end

foo
# => [1, 2, 3]

foo << 4
foo
# => [1, 2, 3, 4]

```

<hr>





### Heredocs

A heredoc lets you create a string that spans multiple lines. It's a way to create a string that contains a lot of text without having to escape all the quotes and newlines. A [squiggly heredoc](https://infinum.com/the-capsized-eight/multiline-strings-ruby-2-3-0-the-squiggly-heredoc) is the same but removes whitespace from the start of lines.

```ruby
# Regular heredoc retains indentation
str1 = <<-DOC
  This is a string
  that spans multiple lines
DOC

# Squiggly heredoc (<<~) removes leading whitespace from the start of each line of the string.
str2 = <<~DOC
  This is a string
  that spans multiple lines
DOC
```




### Metaprogramming


- Technically, things like `attr_accessor` and `has_many` are metaprogramming, since they're macros that define more methods/functions within a class (i.e. they're functions that define functions). 
  - See [berkeley video](https://www.youtube.com/watch?v=UCB57Npj9U0#t=1h7m34s) for more. 

From [here](https://www.youtube.com/watch?v=UCB57Npj9U0#t=1h9m32s): 

> the idea is, with metaprogramming, I can inject code into my Classes. And a lot of the way rails works is ... at run time it's injecting a whole bunch of methods dynamically into that class


Nice example: 

```rb
def delete_an_image
  @image = ActiveStorage::Attachment.find_by_id(delete_an_image_params[:attachment_id])
  @image.purge
  resource = delete_an_image_params[:resource] 
  redirect_method = "edit_#{resource.underscore}_path" # underscore produces snake case
  redirect_to send(redirect_method, delete_an_image_params[:resource_id])    
end

private

def delete_an_image_params
  params.permit(:authenticity_token, :commit, :_method, :resource, :resource_id, :attachment_id)
end
```

The metaprogramming will evaluate the 'redirect_method' e.g. `edit_product_path(delete_an_image_params[:resource_id])`, but would just as easily handle `edit_seller_path` or any other resource/model. 


<hr>

Another example (using `.send` and `.klass`) in [tutorial](https://www.driftingruby.com/episodes/nested-forms-from-scratch) on a form to accept multiple associated records (using simple_form_for).  

Here's some output from `ri klass`:

```
(from gem activerecord-6.0.3.2)
=== Implementation from MacroReflection
------------------------------------------------------------------------
  klass()

------------------------------------------------------------------------

Returns the class for the macro.

composed_of :balance, class_name: 'Money' returns the Money class
has_many :clients returns the Client class

  class Company < ActiveRecord::Base
    has_many :clients
  end

  Company.reflect_on_association(:clients).klass
  # => Client

Note: Do not call klass.new or klass.create to instantiate a
new association object. Use build_association or create_association
instead. This allows plugins to hook into association object creation.
```



### Cool examples that elucidate thinking on ruby methods

From Dees:

```rb
1.public_send(:+, 2)
# => 3

my_hash = {"foo" => "abc", "bar" => "def"}
my_hash.public_send(:[], 'foo')
# => "abc"
```




# Mixins

From [here](https://www.youtube.com/watch?v=UCB57Npj9U0#t=58m20s) it seems a mixin is nothing more than a class which includes a module (which, as one may anticipate, makes the module's methods available to the class). My own thought: seems hardly worth mentioning, since it seems obvious.  












# Odds and ends (mostly methods) to explore some day


- `ObjectSpace.each_object(String){}` from [here](https://ruby-doc.org/stdlib-2.5.1/libdoc/singleton/rdoc/Singleton.html).
- `Module.constants.first(4)` - note you can call `.constants` on some objects
- You can call `.instance_methods` on a class (funnily, you cannot call it on an instance of a class, also funnily, you cannot replace 'instance' with class/module e.g. .class_methods isn't a thing). Example of `.instance_methods` [here](https://ruby-doc.org/core-2.4.2/Module.html#method-i-instance_methods), as well as [docs here](https://apidock.com/ruby/Module/instance_methods)
- This works on a class method `String.method(:hello2).source_location` (not on an instance method though)
- Calling `.source_location` on a method returns the location it was defined, which isn't too useful in irb/rails console, but is probably very handy in an actual application, particularly when debugging. 
- What is monkey patching? From [here](https://www.geeksforgeeks.org/monkey-patching-in-ruby):

> In Ruby, a Monkey Patch (MP) is referred to as a dynamic modification to a class and by a dynamic modification to a class means to add new or overwrite existing methods

- `public_send` as found [here](https://ruby-doc.org/core-3.1.0/Object.html#method-i-remove_instance_variable)
- `.send` found [here](https://stackoverflow.com/a/420837/5783745) to access a class's private methods.

- Example of macros (mentioned [here](https://github.com/alexandreruban/action-markdown#usage), and implemented as code [here](https://github.com/alexandreruban/action-markdown/blob/d636ba7e809ecc46782423149ca61f30c2236c66/lib/action_markdown/attribute.rb)) which defines the `has_markdown` macro. From Walter:

> Devise, to pick a gem at random, has all sorts of macros in it (by this consensus definition). Basically, if you grep for a method and cannot find it at all in either your application or any of the gems' source code, that's a strong indication that it was built by a macro.

and from Tobias:

> to me, macros are mostly class methods adding behavior to a class. this can be setting a configuration (like `set` in sinatra) or generating code in a meta programming way. like `belongs_to`, `enum`, `validates`, callbacks and all these other methods.

And great explanation of `instance_eval` and `class_eval` [here](https://web.stanford.edu/~ouster/cgi-bin/cs142-winter15/classEval.php)

- A note about ruby macros [here](https://stackoverflow.com/questions/47746381/creating-a-macro-in-ruby?noredirect=1#comment132510618_47746381). Basically what ruby calls a macros isn't consistent with what the broader programming world calls macros (so ruby's macros aren't consistent with what a Lisp programmer would call a macro)


- A quick demonstration of duck typing. 
  - Great example [here](https://www.youtube.com/watch?v=UCB57Npj9U0#t=48m)
  - Basic idea: instead of asking: "is this instance a class (or subclass) of some class?", you ask, does it have the same/similar methods to some class. 
  - Example:


```rb

class Thing
  def abc
    puts "hi"
  end
end


t = Thing.new

t.abc
# hi

t.respond_to? "abc"
# true

t.respond_to? :abc
# true

t.respond_to? "pqr"
# false

t.respond_to? :pqr
# false

```

If a particular class shares similar/same methods to another class, then it can be said that they're similar. Like if we had a calss of Mailard and class of Pochard, and they both `respond_to? :quack`, then they both quack so they're probably both ducks (whereas class Goose has `respond_to :quack # false` so it's not a goose. From [here](https://www.youtube.com/watch?v=UCB57Npj9U0#t=48m45s): 

> An object is less defined by ineritance, and more by what the object does.  



> Instead of a String I could use a File here .. it would do just the right thing (since it would have the right methods)

> it breaks you from having to do, like in Java, create an interface and then having to implement all the methods and not use them ([here](https://www.youtube.com/watch?v=UCB57Npj9U0#t=52m25s)






Multi assignment


```ruby
def something
  return nil, 2
end

a, b = something
# => [nil, 2]

a
# => nil

b
# => 2
```

Note that in ruby, this is merely syntactic sugar since methods always return exactly 1 thing, and in this case `return nil, 2` is just syntactic sugar for `return [nil, 2]`. 

This concept is known as [destructuring assignment](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)




# Random notes



- Ruby 3.0 added the 'endless' method (see [here](https://www.bigbinary.com/blog/ruby-3-adds-endless-method-definition))

```ruby
# endless method definition
def raise_to_power(number, power) = number ** power

raise_to_power(2, 5)

32

```

Endless methods can be elegant in rails models like so


```ruby

def sortable? = persisted? && complete?


```

- The 'safe navigation operator' is when you stick an ampersand before calling a method, then it won't error if the method was called on `nil`. Example:


```ruby

arr1 = ["hi"]
arr2 = nil

arr1.first
# => "hi"

arr2.first
# undefined method `first' for nil (NoMethodError)

arr1&.first # has no effect here becauase the object the method is called on isn't nil
# => "hi"

arr2&.first
# => nil <--- no error as it did before

```



- You can run any system command (i.e. bash code) in ruby by simply wrapping it in backticks. 
  - Python is probably the [tool of choice](https://news.ycombinator.com/item?id=40764706) for writing scripts that run system commands, but ruby is great too
  - See [here](https://news.ycombinator.com/item?id=40763640) for some great examples, e.g. parsing git command output 
  - Note ([here](https://news.ycombinator.com/item?id=40764793)) that one gotcha is it doesn't tell you if there was an error in the system code, you have to manually check `$?` (0 is success, and anything else is an error) - e.g. `$?.success?`. Or you can use another method (see stack overflow post linked to from child hn comment)
    - An LLM [tells me](https://chatgpt.com/c/67fb4d5f-865c-8008-aefc-6f495da31919) using `system()` can be a bit more reliable as it will return true if it succeeded, false if it didn't, and nil if the command didn't run. Then you can use `unless` or similar to logically handle.


Some more examples

```rb

`ls`.lines.each do |line|
  puts line
end; nil

total_lines = `wc -l README.md`.to_i
half = total_lines.div 2

puts `head -n #{half} README.md`

# Functional constructions
puts `ls`.lines.map { |name| name.strip.length }

# Regex matching
# This returns the current branch
current_branch_regex = /^\* (\S+)/
output_lines = `git branch`.lines
output_lines.each do |line|
  if line =~ current_branch_regex # match the string with the regex
    puts $1                       # prints the match of the first group  
  end
end

```

- Working with multiple threads (from [same article]() as above):

> If want to work with multiple threads, Ruby is perhaps the one of the easiest language to do it.

```rb

thread = Thread.new do
  puts "I'm in a thread!"
end

puts "I'm outside a thread!"

thread.join
```

so something like this could be used to download multiple files at the same time

```rb

# iterates from i=1 to i=10, inclusive

(1..10).map do |i|

# you can use variables inside commands!
  Thread.new do
    `wget http://my_site.com/file_#{i}`
  end

# do/end and curly braces have the same purpose!
end.each { |thread| thread.join }

```




# Ruby gotchas



```ruby

(1...4).last
# 4

(1..4).last
# 4

(1...4).to_a
# [1, 2, 3]

(1...4).to_a == [1, 2, 3]


```

Why? Well quite simply becuase `.last` is a completely different method on class Array than it is on class Range. It felt very natural for me to think of `.last` like a functional programming language where it would presumably do the same (or equivalent) operation on whatever argument it was passed (e.g. whether it was given a Range, an Array, an ActiveRecord collection or whatever; similarly to how in R we might make a function seamlessly handle for a data.frame or vector, without the programmer having to reach for a separate function for each input type).




# Resources

- Wonderful example of MissileLauncher ruby class [here](https://www.reddit.com/r/programming/comments/3ui1sw/comment/cxfg98b/) (found via [here](https://jvns.ca/blog/2015/11/27/why-rubys-timeout-is-dangerous-and-thread-dot-raise-is-terrifying/) and [here](https://news.ycombinator.com/item?id=40560913)
  - Incidentally, a nice into to mutex and concurrency and thread safety.
- Interesting read [here](https://thomascountz.com/2023/07/30/low-poly-image-generation) showing nice examples of use of modules and classes.










