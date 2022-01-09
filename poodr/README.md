This is a distincly non-thorough summary of some key points from Sandi Metz's *Practical Object Oriented Design with Ruby*




- In addition to Design, Object Oriented Design involves patterns. Design Patterns (1995) is the seminal work on patterns, and it describes patterns as “simple and elegant solutions to specific problems in object-oriented software design” that  you can use to “make your own designs more flexible, modular, reusable, and understandable. 



- SOLID
  - Single responsibility
  - Open-Closed
  - Liskov Substitution
  - Interface Segregation
  - Dependency Inversion


- In object oriented programming, we define methods on objects. Classes are objects. 



#### Write loosely coupled code

> There's a simple way to avoid depending on positional arguments ... change the ode to take *keyword* arguments. 

From discussion: it seems that using keyword arugments should be the norm, unless there's a really obvious assumption (for example `findThingByAttribute(attr, optionalFlags)` would almost always have the attribute as the first argument). 

From chat with an experienced rubyist: 

> after reading (POODR) I kinda switched from like 20/80 to 80/20 

i.e. uses keyword args 80% of the time now, but also mentioned they won't impose that standard on a project if others aren't keen).


TL;DR use keyword arguments \~80% of the time. 

Example:

```ruby
def hi(name, age)
  puts "Hi, #{name}, you're #{age}"
end

hi("Sue", 25)
# Hi, Sue, you're 25

# This could be rewritten as
def hii(name:, age:)
  puts "Hi, #{name}, you're #{age}"
end

hii("Sue", 25)
# ArgumentError (wrong number of arguments (given 2, expected 0; required keywords: name, age))
hii(name: "Sue", age: 25)
# Hi, Sue, you're 25
hii(age: 25, name: "Sue")
# Hi, Sue, you're 25
```

Another way to write loosely couple code is to explicity define defaults, right in the argument list


```ruby

def hotdog(amount)
  puts "Hi, I'd like #{amount} hotdogs, please!"
end

hotdog(3)
# Hi, I'd like 3 hotdogs, please!

# Could be given a default value of 5 like so

def hotdog(amount: 5)
  puts "Hi, I'd like #{amount} hotdogs, please!"
end

hotdog
# Hi, I'd like 5 hotdogs, please!
hotdog(12)
# ArgumentError (wrong number of arguments (given 1, expected 0))
hotdog(amount: 12)
# Hi, I'd like 12 hotdogs, please!
```

Note that when defining a default paramter for a method *without* keywords, it's defined a little differently:


```ruby

def hotdog(amount = 4)
  puts "Hi, I'd like #{amount} hotdogs, please!"
end

hotdog
# Hi, I'd like 4 hotdogs, please!

hotdog(7)
# Hi, I'd like 7 hotdogs, please!

hotdog(amount: 9)
# Hi, I'd like {:amount=>9} hotdogs, please!
# WOW - that's quite dangerous! Be wary 

```
























