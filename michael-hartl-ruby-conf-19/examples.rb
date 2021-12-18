

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