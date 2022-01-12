This is a distincly non-thorough summary of some key points from Sandi Metz's *Practical Object Oriented Design with Ruby*




- In addition to Design, Object Oriented Design involves patterns. Design Patterns (1995) is the seminal work on patterns, and it describes patterns as “simple and elegant solutions to specific problems in object-oriented software design” that  you can use to “make your own designs more flexible, modular, reusable, and understandable. 



- SOLID
  - Single responsibility
  - Open-Closed
  - Liskov Substitution
  - Interface Segregation
  - Dependency Inversion


- In object oriented programming, we define methods on objects. Classes are objects. 



# Writing loosely coupled code (pp 49-50)

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

Note that when defining a default parameter for a method *without* keywords, it's defined a little differently:


```ruby

def hotdog(amount = 4)
  puts "Hi, I'd like #{amount} hotdogs, please!"
end

hotdog
# Hi, I'd like 4 hotdogs, please!

hotdog(7)
# Hi, I'd like 7 hotdogs, please!


# BE CAREFUL OF THIS ONE - when you *think* you're working with a function expecting keyword arguments, 
# but in fact you're not. Then it will pass the hash through 
hotdog(amount: 9)
# Hi, I'd like {:amount=>9} hotdogs, please!
# WOW - that's quite dangerous! Be wary 

```



# Responsibilities, Dependencies, and Interfaces

(p64) The methods that make up the **public interface** of your class comprise the face it presents to the world. They: 

- Reveal its primary responsibility.
- Are expected to be invoked by others.
- Will not change on a whim.
- Are safe for others to depend on.
- Are thoroughly documented in the tests.

All other methods in the class are part of its **private interface**. They:

- Handle implementation details.
- Are not expected to be sent by other objects.
- Can change for any reason whatsoever
- Are unsafe for others to depend on.
- May not even be referenced in the tests


If you think of a class as having a single purpose, then the things it does (its more specific responsibilities) are what allow it to fulfill that purpose.



# Determining if a Class Has a Single Responsibility

- How can you determine if the Gear class contains behaviour that belongs somewhere else? One way is the pretend that it's sentient and to interrogate it. If you rephrase every one of its methods as a question, asking the question ought to make sense. For example: "*Please, Mr. Gear, what is your ratio?*" seems perfectly reasonable, while "*Please, Mr Gear, what are your gear_inches?*" is on shaky ground, and "*Please, Mr. Gear, what is your tire (size)?*" is downright ridiculous. (p22)

- Why have a Single Responsibility? Because applciations are easy to change if classes are easy to reuse. (p21)




# Enforce Single Responsibility Everywhere

Why? (p31)

- Expose previously hidden qualities

  > Refactoring a class so that all of its methods have a single responsibility has a clarifying effect on the class. 

- Avoid the need for comments

  > Because comments are not executiable, they are merely a form of decaying documentation. 

- Encourage reuse
- Makes it easy to move to another class 



# Inheritance (pp 112-113) 

- It goes without saying that objects receive messages. No matter how complicated the code, the receiving object ultimately handles any message in one of two ways. It either responds directly or it passes the message on to some other object for a response. 

- Languages that allow objects to have multiple parents are described as having multiple ineritance, and the designers of these languages face interesting challenges. When an object with multiple parents receives a message that it does not understand, to which parent ought it forward that message? If more than one of its parents implements the message, which implementation has priority? As you might guess, things get complicated quickly. 

- Ruby has single inheritance. A superclass may have many subclasses, but each subclass is permitted only one superclass. 

- Even if you have never explicitly created a class hierarchy of your own, you use inheritance. When you define a new class but do not specify its superclass, Ruby automatically sets your new class's superclass to `Object`. Every class you create is, by definition, a subclass of something. 
  - You also benefit from automatica delegation of messages to superclasses. When an object receives a message it does not understand, Ruby automatically forwards that message up the superclass chain in search of a matching method implementation. A simple example is `NilClass`: 
    - Remember that in Ruby, nil is an instance of class `NilClass`; it's an object like any other. Ruby contains two implementations of `nil?`, one in `Nilclass` and the other in `Object`. The implementation in `NilClass` unconditionally returns `true`, the one in `Object`, `false`. 
    - When you send `nil?` to an instance of `NilClass`, it, obviously, answers `true`. When you send `nil?` to anything else, the message travels up the hierarchy from one superclass to the next until it reaches `Object`, where it invokes the implementation that answers `false`. Thus, `nil` reports that it *is* nil, and all other objects report that they are not. This elegantly simple solution illustrates the power and usefulness of inheritance. 
- Misapplying inheritence is painful. From p 114 there's a (length) example. 
  - Shows that `Bicycle` class is a oncrete class that was not written to be subclassed (it combines behaviour that is general to all bikes with behaviour that is specific to road bikes, so when you subclass it, you inherit all the specifics too - obviously bad design there). 
    - To solve this you have to think carefully to **find the abstraction** (more on p116)
- (p120) **It's easier to promote a method up to a superclass than to demote it down to a subclass** - so I guess that means it's best to lean on the side of abstracting *too little* intot he superclass than too much! 

- p 136 shows an example of a *hook*
  - I *think* it's a 'shell' method in the superclass that subclasses can override e.g. `def local_spares {} end`

- (p160) **Preemptively Decouple Classes** Avoid writing code that requires its inheritors to send `super`; instead use hook messages to allow subclasses to participate while absolving them of responsibility for knowing the abstract algorithm. 
  - Inheritance, by nature, adds powerful dependencies on the structure and arrangement of code. Writing code that requires subclasses to send super adds an additional dependency; avoid this if you can. 
- (p160) **Create Shallow Hierarchies**: 
  - Simple, narrow hierarchies are easy to understand. 
  - Shallow, wide hierarchies are slightly more complicated. 
  - Deep, narrow hierarchies are a bit more challenging and unfortunately have a natural tendency to get wider. 
  - Deep, wide hierarchies are difficult to understand and costly to maintain. 


# Create Flexible Interfaces

- **The Law of Demeter** (p80) is a set of coding rules that results in loosely coupled objects. Loose coupling is nearly always a virtue but is just one component of design and must be balanced against competing needs. Some Demeter violations are harmless, but others expose a failure to correctly identify and define public interfaces. 
- Demeter restricts the set of objets to which a method may *send messages*; it prohibits routing a message to a third object via a second object of a different type. Demete is often paraphrased as "only talk to your immediate neighbors" or "use only one dot". 
  = Each line is a message chain containing a number of dots (periods). These chains are colloquially referred to as *train wrecks*; each method name represents a train car, and the dots are the connections between them. These trains are an indication that you migth be violating Demeter. 
    - **Avoiding Violations** One comon way to remove train wrecks from code is to use delegation to avoid the dots. In object-oriented terms, to *delegate* a message is to pass it on to another object, often via a wrapper method. The wrapper method encapsulates, or hides, knowledge that would otherwise be embodied in the message chain. 
    - There are a number of ways to accomplish delegation. Ruby provides support via `delegate.rb` and `forwardable.rb`, wwhich make it easy for an object to automatically intercept a message sent to *self* and to instead send it somewhere else. 
    - Demeter is tryign to tell you something, and it isn't "use more delegation". Message chains like `customer.bicycle.wheel.rotate` occur when your design thoughts are unduly influenced by objects you already know. Your familiarity with public interfaces of known objects may lead you to string together long message chains to get at distant behaviour. 
      - Reaching across disparate objects to invoke distant behaviour is tantamount to saying: "There's some behaviour way over there that I need right here, and I know how to go get it". The code knows not only what it wants (to `rotate`) but *how* to navigate through a bunch of intermediate objects to reach the desired behaviour. **This coupling creates all sorts of problems**, the most obvious is that something may need to change simply because something else does somewhere else in the message change. That's bad. 
    - SC Note: I was not sure why Metz is *so* strongly against *train wrecks*. I asked the community giving the example `@user.physician.appointments.first` and they said there are exceptions to every rule. (quotes from Dees):

      > activerecord association relationships and scopes are a sort of special case where the DSL and framework support make it relatively ok to do that. But if you're dealing with your own plain ruby objects, that'd be an indication that you have a design problem. 

      > it's (`@user.physician.appointments.first`) just excessive coupling and can pretty much always be abstracted away which makes for lighter maintenance work when things change



# Understanding Duck Typing (p85)

- The purpose of object-oriented design is to reduce the cost of change. Now that you know that messages are at the design center of your application, and now that you are committed to the construction of figorously defined public interfaces, you can combine these two ideas into a powerful design technique that further reduces your costs. This technique is known as **duck typing**. Duck types are public interfaces that are not tied to any specific class. These across-class interfaces add enormous flexibility to your application by replacing costly dependencies on class with more forgiving dependencies on messages. 
- Programming languages use the term *type* to describe the category of the contents of a variable. Procedural languages provide a small, fixed number of types, generally used to describe kinds of *data*. Even the humblest language defines types to hold strings, numbers, and arrays. 
- It is knowledge of the category of the contents of a variable, or its type, that allows an application to have an exceptation about how those contents will behave. Applications quite reasonably assume that numbers can be used in mathematical experessions, strings concatenated, and arrays indexed. 
- In Ruby, these expectations about the behaviour of an object come in the form of beliefs about its public interface. **If one object knows another's type, it knows to which messages that object can respond**. 
- Users of an object need not, and should not, be concerned about its class. Class is just one way for an object to acquire a public interface; the public interface an object obtains by way of its class may be one of several that it contains. Applications may define many public interfaces that are not related to one specific class; these interfaces cut across class. Users of any object can blithely expect it to act like any, or all, of the public interfaces it implements. **It's not what an object *is* that matters, it's what it *does***
- **Polymorphism** in OOP refers to the ability of many different objects to respond to the same message. Senders of the message need not care about the class of the receiver; receivers supply their own specific version of the behaviour. (p94) 
- Messages are at the center of OO applications, and they pass among objects along public interfaces. Duck typing detaches these public interfaces from specific classes, creating virtual types that are defined by what they do instead of by who they are.  (p103)







# Areas to do more on

- pg 98 - documenting duck types
- pg 100 - conquering a fear of duck typing
- pg 101 - static vs dynamic typing. 

















































