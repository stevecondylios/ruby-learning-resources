This repo contains some useful learning resources for the ruby programming language. 

Most resources are from stated sources (e.g. *Learn Ruby The Hard Way*), but some is simply my own playing around for learning and demonstration purposes. 

At some stage it would be great to:

1. Create a list of ruby/rails 'gotchas' - a list of things that an experienced programmer who is new to ruby/rails could find tricky or difficult, particularly things that aren't intuitive. Examples:
  - When calling a method, ruby will first look within the class, then the module, then `method_missing` , then at any ancestor classes
  - When working in the view, you’ll automagically have access to any helpers defined in the helper file of the same name. E.g. ‘thing’ views will have access to anything defined in `things_helpers.rb`
  - Don’t edit `Gemfile.lock` manually, instead, edit `Gemfile` then run `bundle install` which will update the lock file
2. Create a single readme intro to ruby, so it can be used an a very quick primer for an experienced programmer or someone who used ruby before but forgot its syntax. 




