

# TL;DR Class methods vs Instance methods


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












# Understanding class methods vs instance methods. 

```rb
String.methods

String.method(:hello).source_location
String.new.methods.include?(:hello)
```





```rb
String.methods.length
=> 191
String.new.methods.length
=> 274


class String
  def hi
    puts "hi"
  end
end


String.methods.length
=> 191
String.new.methods.length
=> 275
```


> Because `String.methods` is all class methods, but if you want instance methods you gotta check an instance

SC note: So if I'm not mistaken, `class String def hi puts "hi" end end` must have added an *instance* method. Correct? 








```rb
String.methods.length
=> 191
String.new.methods.length
=> 275

class String
  def palindrome?
    self == self.reverse
  end  
end  
=> :palindrome?

String.methods.length
=> 191
String.new.methods.length
=> 276
```

Adding this method that uses `self` *didn't* affect the number of class methods (although it did `+=` the number of instance methods). Why? 



**Let's explore an example.** 

Look at the `Test` class:

```rb
Test
NameError: uninitialized constant Test
from (pry):1:in `<main>'
```
Whooops, it doesn't exist. Better create it:


```rb
class Test
end
```


View methods for class and instance of class:

```rb
Test.methods.length
=> 189
Test.new.methods.length
=> 93
```

### Creating a **class** method ([2 ways](https://www.rubyfleebie.com/2007/04/09/understanding-class-methods-in-ruby/))

Create a new class method called `class_method`

```rb
class Test #Test is now an instance of a built-in class named Class
  def Test.class_method
    "I'm a class method."
  end
end
```

Check number of class and instance methods respectively:

```rb
Test.methods.length
=> 190
Test.new.methods.length
=> 93
```


Cool, we created a class method! 


Here's another way to create a class method:

```rb
class Test
  def self.another_class_method
    "I'm a class method."
  end
end
```


```rb
Test.methods.length
=> 191
Test.new.methods.length
=> 93
```

So we again successfully created a class method. 



### Creating an **instance** method


```rb
Test.methods.length
=> 191
[34] pry(main)> Test.new.methods.length
=> 93


class Test
  def hi
    puts "hi"
  end
end


Test.methods.length
=> 191
[37] pry(main)> Test.new.methods.length
=> 94
```

`+=` 1 to the instance methods count. 

Let's try one with `self`

```rb
class Test
  def palindrome?
    self == self.reverse?
  end  
end  
=> :palindrome?

Test.methods.length
=> 191

Test.new.methods.length
=> 95

```

Again, it increased the number of instance methods by 1. 

