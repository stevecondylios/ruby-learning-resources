
I stumbled upon Michael Hartl's Ruby Conf 2019 talk: https://www.youtube.com/watch?v=NGXp6_-nc4s

The video provides an amazing intro to ruby that moves quickly and doesn't focus exclusively on syntax, but on doing some real things, like defining some class methods and making a gem. 



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




From [here](https://www.rubyfleebie.com/2007/04/09/understanding-class-methods-in-ruby/):

> Once you understand that classes are objects, this use of the self variable to define a class method finally makes sense.




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

Create a new class called `Test`

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














