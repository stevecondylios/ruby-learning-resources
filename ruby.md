



Quick summary of things in this file: 

- How to use pry to debug, view docs, and view source code
- Singletons
- Scopes
- Super
- Splat and keyword arguments
- Modules
- Ruby Gems
- Odds and Ends to explore some day








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

```



# Regular expressions in ruby 

From Agile Web Development in Rails:

> A regular expression lets you specify a *pattern* of characters to be matched in a string. In Ruby, you typically create a regular epression by writing `/pattern/` or `%r{pattern}`. (p52). Programs typically use the *match operator* `=~` to test strings against regular expressions. 



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


[From here](https://medium.com/@noordean/understanding-ruby-blocks-3a45d16891f1):

> Ruby blocks are anonymous functions that can be passed into methods. Blocks are enclosed in a do-end statement or curly braces {}. do-end is usually used for blocks that span through multiple lines while {} is used for single line blocks. Blocks can have arguments which should be defined between two pipe | characters.


```ruby 

# A block
[1, 2, 3].each { |n| puts n }

# Also a block
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









# Procs

From [here](https://medium.com/podiihq/ruby-blocks-procs-and-lambdas-bb6233f68843):

> Ruby introduces procs so that we are able to pass blocks around. 

> Proc objects are blocks of code that have been bound to a set of local variables. Once bound, the code may be called in different contexts and still access those variables.


**2 ways to define a proc**

```ruby
myproc = Proc.new {|num| puts num**3 }

myproc = proc {|num| puts num**3}

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








TODO
- HEREDOCs and [Squiggly heredocs](https://infinum.com/the-capsized-eight/multiline-strings-ruby-2-3-0-the-squiggly-heredoc)








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









# Ruby Gems


[How to create one](https://www.youtube.com/watch?v=NGXp6_-nc4s&t=11m43s) - simply run:

```sh
bundle gem rubyconf_palindrome # creates gem
# cd into gem
bundle exec rake test # Runs tests
```

Side note: incidentally, [this](https://www.youtube.com/watch?v=NGXp6_-nc4s&t=12m) is an excellent \~10 minute example of
test driven development. 












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


**To look up source code for a method**

```ruby

$ File.link
# NOTE: if this doesn't work, don't forget to require 'pry-doc'

```







# Scopes

**Scopes TL;DR** - [Don't use scopes!](https://piechowski.io/post/why-is-default-scope-bad-rails/) - The case for not using scopes is strong: they look convenient, but really just mess with your queries - steer clear. 





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

























