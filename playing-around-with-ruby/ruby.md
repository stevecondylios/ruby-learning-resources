



Quick summary of things in this file: 

- How to use pry to debug, view docs, and view source code
- Singletons
- Scopes
- Super
- Splat and keyword arguments
- Modules
- Ruby Gems
- Odds and Ends to explore some day




# Super









# Splat





# Blocks, procs, and lambdas


From [here](https://medium.com/@noordean/understanding-ruby-blocks-3a45d16891f1):

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
















# Ruby language capabilities and quirks

- You can assign multiple variables like this: `a, b = 2, 3`
- `.self` can [sometimes be ommitted](https://www.youtube.com/watch?v=NGXp6_-nc4s&t=19m05s), since without it the default is the current object. For example, this can be re-written:

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


> When calling a method, ruby will first look within the class, then the module, then `method_missing` , then at any ancestor classes
 - TODO `method_missing` example here
- HEREDOCs and [Squiggly heredocs](https://infinum.com/the-capsized-eight/multiline-strings-ruby-2-3-0-the-squiggly-heredoc)



# Modules

From [ruby docs](https://ruby-doc.org/core-2.4.2/Module.html#method-i-instance_methods): 

> A `Module` is a collection of methods and constants. The methods in a module may be instance methods or module methods. Instance methods appear as methods in a class when the module is included, module methods do not.

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








# Ruby Gems


[How to create one](https://www.youtube.com/watch?v=NGXp6_-nc4s&t=11m43s) - simply run:

```sh
bundle gem rubyconf_palindrome
```













# Odds and ends (mostly methods) to explore some day


- `ObjectSpace.each_object(String){}` from [here](https://ruby-doc.org/stdlib-2.5.1/libdoc/singleton/rdoc/Singleton.html).
- `Module.constants.first(4)` - note you can call `.constants` on some objects
- You can call `.instance_methods` on a class (funnily, you cannot call it on an instance of a class, also funnily, you cannot replace 'instance' with class/module e.g. .class_methods isn't a thing). Example of `.instance_methods` [here](https://ruby-doc.org/core-2.4.2/Module.html#method-i-instance_methods), as well as [docs here](https://apidock.com/ruby/Module/instance_methods)
- This works on a class method `String.method(:hello2).source_location` (not on an instance method though)
- Calling `.source_location` on a method returns the location it was defined, which isn't too useful in irb/rails console, but is probably very handy in an actual application, particularly when debugging. 
- What is monkey patching? From [here](https://www.geeksforgeeks.org/monkey-patching-in-ruby):

> In Ruby, a Monkey Patch (MP) is referred to as a dynamic modification to a class and by a dynamic modification to a class means to add new or overwrite existing methods


































































































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
then run `irb` or `rails c`

```ruby
require 'pry'
require 'pry-doc'

# Don't forget to run 'pry' command to enter pry
pry 
```


**To look up documentation for a method**


```ruby
? File.link # Grabs docs for File.link method


```


**To look up source code for a method**

```ruby

$ File.link

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

























