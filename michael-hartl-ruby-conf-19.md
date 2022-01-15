

This is a TL;DR of [Michael Hartl's Ruby Conf 2019 talk](https://www.youtube.com/watch?v=NGXp6_-nc4s)

The video provides an amazing intro to ruby that moves quickly, touches on syntax, defines a method, makes a ruby gem, and uses the gem in a real software application. It's an excellent example of test driven development (TDD), with approximately 8 tests written along the way.  


# Do some string manipulations in ruby

The first 11 minutes shows how to manipulate strings and place some logic into a method. 


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
# ["H", "e", "l", "l", "o", ",", " ", "w", "o", "r", "l", "d", "!"]

s.chars
# ["H", "e", "l", "l", "o", ",", " ", "w", "o", "r", "l", "d", "!"]

s.split("").reverse
# ["!", "d", "l", "r", "o", "w", " ", ",", "o", "l", "l", "e", "H"]

s.split("").reverse.join
# "!dlrow ,olleH"

# Is it a pallendrome?
s == s.split("").reverse.join

# Does this logic work for a palindrome? 
p = "deified"
p == p.split("").reverse.join
# true




def palindrome?(string)
  string == string.reverse
end

palindrome?(s)
# false
palindrome?(p)
# true




class String
  def palindrome?
    self == self.reverse
  end
end

"Hello, world!".palindrome?
# false

"deified".palindrome?
# true



```




# Place a method into a gem

[Here](https://www.youtube.com/watch?v=NGXp6_-nc4s&t=11m20s) the method is moved into a gem for easy re/use. 


```sh
bundle gem rubyconf_palindrome
cd rubyconf_palindrome
```

































