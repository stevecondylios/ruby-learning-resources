
This may become its own repo. For now including in ruby-learning-resources


The purpose is to collect rails tid-bits that will serve as a useful reminder for anyone forgetful. 


things to include: fixtures, factories, testing (defaults, but also with RSpec). 



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























