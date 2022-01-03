
This may become its own repo. For now including in ruby-learning-resources



# Resources


### Using `pry` to debug, view docs, and view source (for both irb and rails c)

- Rubyconf 2019 [video on pry and debugging](https://www.youtube.com/watch?v=GwgF8GcynV0) by Jim Weirich
  - `ls` to view objects available to you
  - `cd ../` etc to navigate 
  - `$` to show the current source of where your `binding.pry` is (or wherever you've cd'd into)
  - `$ Module` or `$ method` to see other stuff's source
    - Great [examples here](https://stackoverflow.com/a/7056610/5783745) 


Note that the run pry in rails, you add `binding.pry`

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

























