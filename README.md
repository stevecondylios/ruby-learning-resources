This repo contains some useful learning resources for the ruby programming language. 

Most resources are from stated sources (e.g. *Learn Ruby The Hard Way*), but some is simply my own playing around for learning and demonstration purposes. 

At some stage it would be great to:

1. Create a list of ruby/rails 'gotchas' - a list of things that an experienced programmer who is new to ruby/rails could find tricky or difficult, particularly things that aren't intuitive. 
  - Examples:
    - When calling a method, ruby will first look within the class, then the module, then `method_missing` , then at any ancestor classes
    - When working in the view, you’ll automagically have access to any helpers defined in the helper file of the same name. E.g. ‘thing’ views will have access to anything defined in `things_helpers.rb`
    - Don’t edit `Gemfile.lock` manually, instead, edit `Gemfile` then run `bundle install` which will update the lock file
    - `my_hash = {foo: "abc", bar: "def"}` has symbol keys, `my_hash = {"foo": "abc", "bar": "def"}`, surprisingly also has symbol keys, `my_hash = {"foo" => "abc", "bar" => "def"}` seems to be the way to define a hash with string keys.
  - Possible names: rails-speedrun, rails-unmagic
  - Useful references:
    - Stack Overflow question on [ruby gotchas](https://stackoverflow.com/questions/372652/what-are-the-ruby-gotchas-a-newbie-should-be-warned-about)
2. Create a single readme intro to ruby, so it can be used an a very quick primer for an experienced programmer or someone who used ruby before but forgot its syntax. 


### Important resources

- List of [keyboard shortcuts for IRB](https://github.com/ruby/irb/issues/322#issuecomment-1001298710) can be found at: https://readline.kablamo.org/emacs.html








