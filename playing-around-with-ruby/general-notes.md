




#### No need to use `.self` all the time

This can be re-written:

```ruby

class String
  def palindrome?
    self == self.reverse
  end
end
```

as this

```ruby

class String
  def palindrome?
    self == reverse
  end
end
```

[since](https://www.youtube.com/watch?v=NGXp6_-nc4s&t=19m05s): 

> We can remove the `self.` ... because by default is just what the current object is. 



#### How to create a ruby gem

From [here](https://www.youtube.com/watch?v=NGXp6_-nc4s&t=11m43s):

```sh
bundle gem rubyconf_palindrome
```



















