
This may become its own repo. For now including in ruby-learning-resources


The purpose is to collect rails tid-bits that will serve as a useful reminder for anyone forgetful. 


things to include: fixtures, factories, testing (defaults, but also with RSpec). 


# Intro

- The average rails app has 1.03 lines of test code for every line of code in the app! [Source](https://semaphoreci.com/blog/2018/04/11/state-of-testing-in-rails.html)



# Incredibly important resources:

- Railsdiff (explained [here](https://www.youtube.com/watch?v=ljgmjoIv4Y8&t=5m46s), link [here](https://railsdiff.org/)) - use it when upgrading from one rails version to another.
- How to look up rails documentation: [api.rubyonrails.org](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/Table.html#method-i-timestamps) - **use the search bar on top left**
- [Rails guides](https://guides.rubyonrails.org/) (these aren't 'read once and forget' - experienced devs use them daily)


# How to setup your working environment (IDE, terminal etc):

- Great video on vscode extensions [here](https://www.youtube.com/watch?v=VXTmd-4jx8g)



# Notes from [Rails 7 demo](https://www.youtube.com/watch?v=mpWFrUwAN88)

- `.deliver_later` knows to run inline in development, and for it to work properly (i.e. asynchonously) in production, it requires some setup of (??) 
- Rich text fields
- 








# Scopes

In your controller you might want to only show published posts: 

```ruby

def index

  @posts = Post.all.where(status: "Published")

end
```

Another (more elegant) way to do this is jumping into your Post model and creating a scope (the `scope` method appears to accept 2 arguments, a name for the scope, and a lambda that contains the code for the scope), such that:


```ruby

scope :published, -> { where(status: "Published") }

```

Then in your controller you can have this:


```ruby

@posts = Post.published

```

And it will do the exact same thing. 

So TL;DR scopes are a great way to keep controller code DRY, and move some controller code into the model. 



Note: **Avoid** using `default_scope`s - they tend to [make a massive mess](https://stackoverflow.com/questions/25087336/why-is-using-the-rails-default-scope-often-recommend-against)!. 















# Testing 

- Awesome [rails guide on testing](https://guides.rubyonrails.org/testing.html)
  - It covers **unit**, **functional**, **integration**, and **system** tests


The purpose of testing is to:

> ensure your code adheres to the desired functionality even after some major code refactoring.


> Rails tests can also simulate browser requests and thus you can test your application's response without having to test it through your browser.




# RSpec

What does `let` do? `let` simply creates a variable [but it lazy evaluates it](https://pololu.github.io/rpicsim/file.IntroductionToRSpec.html#label-Let+variables), in other words, it only evaluates it when the variable is actually used. I'm pretty sure it memoizes (which is approximately equal to 'caches') it too, so it's kinda 'made once, used many times' rather than being recreated over and over. 












# Summary of notes from Agile Web Development with Rails 5


How to think of classes and objects in an object oriented language like ruby: 

> When you write object-oriented code, you're normally looking to model concepts from the real world. Typically, during this modelling process you discover categories of thinks that need to be represented. In an online  store, the concept of a line item could be such a category. In Ruby, you'd define a *class* to represent each of these categories. You then use this class as a kind of factory that generates *objects* - instances of that class. An object is a combination of state (for example, the quantity and the product ID) and methods that use the state (perhaps a method to calculate the line the line item's total cost. (p47)

- You create objects by calling a *constructor*, a special method associated with a class. The standard constructor is called `new()`. 
- You invoke methods by sending a message to an object. The message contains the method's name, along with any parameters the method may need. 
- Rails uses *symbols* to identify things. In particular, it uses them as keys when naming method parameters and looking things up in hashes. 
  - A symbol looks like a variable name, but it's prefixed with a colon. You can think of symbols as string literals magically made into constants. Alternatively, you can consider the colon to mean *thing named*, so `:id` is the thing named `id`. 






















