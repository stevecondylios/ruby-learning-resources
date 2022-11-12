This file contains a quick example of each of the 59 enumerable methods found [here](https://ruby-doc.org/core-3.0.2/Enumerable.html). It's mentioned [here](https://www.youtube.com/watch?v=nZNfSQKC-Yk&t=14m10s) that it's a great idea to know a little about each: 

> If you have time, because it's so important, write an example for each enumerable method

The three big ones: `.each`, `.map`, and `.inject`. But there are 56 more!


- Enumerable one-pager of documentation: 




### `.each`


```ruby
pets = "cat", "mouse", "dog", "lizard", "tiger"]
pets.each do |pet| 
  puts "I have a #{pet}"
end
# I have a cat
# I have a mouse
# I have a dog
# I have a lizard
# I have a tiger 
```



### `.map`

```ruby
pets.map do |pet| 
  pet + "aaa"
end
# => ["cataaa", "mouseaaa", "dogaaa", "lizardaaa", "tigeraaa"]

pets.map{ |pet| pet + "aaa" }
# => ["cataaa", "mouseaaa", "dogaaa", "lizardaaa", "tigeraaa"]
```

### `.inject` 


```ruby





```

### `.count` 


```ruby





```




### `.group_by` 


```ruby





```






### `.partition` 


```ruby





```





### `.any? 


```ruby
arr = [1,2,3,4]
arr.any? { |el| el >4 }
# => false

arr2 = [1,2,3,4,5]
arr2.any? { |el| el >4 }
# => true 
```







### `.all?` 


```ruby





```








### `.none?` 


```ruby





```










### `.zip` 


```ruby





```







