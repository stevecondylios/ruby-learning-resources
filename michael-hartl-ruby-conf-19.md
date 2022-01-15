

This is a TL;DR of Michael Hartl's Ruby Conf 2019 talk: https://www.youtube.com/watch?v=NGXp6_-nc4s

The video provides an amazing intro to ruby that moves quickly, touches on syntax, defines a method, makes a ruby gem, and uses the gem in a real software application. It's an excellent example of test driven development (TDD), with approximately 8 tests written along the way.  





```ruby

# How class methods work


# Suppose we have a string

s = "hello, world!"
s.length
s.empty? # 

s.split(" ")
"hello,         world!".split(" ") # Note that it doesn't split on each space, but on whitespace

"hello,         world!".split(/ /) # using regex rather than default whitespace

s.split("")

s.chars

s.split("").reverse
s.split("").reverse.join

# Is it a pallendrome?
s == s.split("").reverse.join







class String
  def palindrome?
    self == self.reverse
  end
end


```








