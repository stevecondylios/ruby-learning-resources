

# Singleton

Resources

- [Medium article](https://medium.com/rubyinside/class-methods-in-ruby-a-thorough-review-and-why-i-define-them-using-class-self-af677ede9596)


### About Singletons

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


























