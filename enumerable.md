This file contains a quick example of each of the 59 enumerable methods found [here](https://ruby-doc.org/core-3.0.2/Enumerable.html). It's mentioned [here](https://www.youtube.com/watch?v=nZNfSQKC-Yk&t=14m10s) that it's a great idea to know a little about each: 

> If you have time, because it's so important, write an example for each enumerable method

The three big ones: `.each`, `.map`, and `.inject`. But there are 56 more!


- Enumerable one-pager of documentation: 
- Also note that using `ri` in the command line gives really great docs with examples. E.g. in terminal: `ri inject`



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

### `.inject` AKA `.reduce` 

- See `ri inject` docs for example

> Combines all elements of enum by applying a binary operation, specified by a block or a symbol that names a method or operator. The inject and reduce methods are aliases. There is no performance benefit to either.

```ruby
(1..10).reduce(:+)
# => 55
(1..10).reduce(:*)
# => 3628800
(1..10).inject { |sum, n| sum + n } # Same thing done another way
# => 55
```

### `.count` 

```ruby
(1..10).to_a.count
```

### `.select`

Note: see below for more ways of using enumerable on an ActiveRecord object, and alternatives for .select

```ruby
(1..10).to_a.select{ |el| el > 5}
# => [6, 7, 8, 9, 10]
```

### `.min` and `.max` 


```ruby
[4,3,11,9,555].min
# => 3
irb(main):005:0> [4,3,11,9,555].max
# => 555
```





### `.group_by` 

From `ri group_by`:

> Groups the collection by result of the block.  Returns a hash where the keys are the evaluated result from the block and the values are arrays of elements in the collection that correspond to the key.	

Example from `ri group_by`

```ruby
(1..6).group_by { |i| i%3 }
# => {1=>[1, 4], 2=>[2, 5], 0=>[3, 6]}
```








### `.partition` 



```ruby



```





### `.any?` 


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
arr.all? { |el| el <= 4 }
# => true
arr2.all? { |el| el <= 4 }
# => false

[45, 5, 75].all? do |num|
  num % 5 == 0
end
# => true

[45, 5, 75, 7].all? do |num| 
  num % 5 == 0 
end
# => false
```








### `.none?` 


```ruby





```



### `compact` and `compact!`

Removes all `nil` elements from itself. 

Note: to get docs for `compact!`, escape the bang. E.g. `ri compact\!`


```ruby
[1, false, nil, 0, 1000, nil, 4.543].compact
# => [1, false, 0, 1000, 4.543]
```






### `.zip` 

Example from `ri zip`

```ruby
a = [:a0, :a1, :a2, :a3]
b = [:b0, :b1, :b2, :b3]
c = [:c0, :c1, :c2, :c3]
a.zip(b, c)
# => [[:a0, :b0, :c0], [:a1, :b1, :c1], [:a2, :b2, :c2], [:a3, :b3, :c3]]
```



### `.flatten`

Appears to combine an array of arrays into one array. 


```ruby
[[1, 2], [3], [4, 5, 6]].flatten
# => [1, 2, 3, 4, 5, 6]

[[1, 2], [[3], 4, 5], [[[6]]]].flatten
# => [1, 2, 3, 4, 5, 6]
```











# A few notes in relation to ActiveRecord

Note that for some queries and operations, there's (one or more) AR ways of doing it, and (one or more) enumerable ways of doing it.

Generally, allowing AR to do it pushes the work to the db, which is generally better practice, since it won't hog memory in your application.

There are some common patterns of queries that are occasionally used. Here are some examples.



```ruby

# uses application's memory (also possibly an N + 1)
users = studio.bookings.map(&:users)

# whereas this uses the db and avoids N + 1.
users = User.joins(:bookings).where(bookigns: { studio_id: studio.id }).distinct


# Or with complexity of some bookings not having emails (guest users), claude suggests using two queries:


users = User.joins(:bookings).where(bookings: { studio_id: studio.id }).distinct

# To find guest emails:
guest_emails = Booking.where(studio_id: studio.id, user_id: nil).where.not(email: nil).pluck(:email).uniq


```




### Alternatives to `.select`


Here are some ways to filter child records for an ActiveRecord object. Note: I don't actually know the pros/cons of each yet.


```ruby
@teacher = Teacher.includes(:students).find(1) # Assuming teacher with id 1

# Remove students with an average grade below 70
@teacher.students = @teacher.students.reject { |student| student.average_grade < 70 }

# Keep only students in grade 10
@teacher.students.select! { |student| student.grade == 10 }

# Remove students who are above 18 years old
@teacher.students.delete_if { |student| student.age > 18 }

# Remove some specific students
students_to_exclude = [Student.find(3), Student.find(7)] # Assume these are student objects
@teacher.students = @teacher.students.excluding(*students_to_exclude)

```




