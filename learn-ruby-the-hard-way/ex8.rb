formatter = "something here %{first} %{second} (and here)  %{third} % {fourth}"

puts formatter % {first: 1, second: 2, third: 3, fourth: 4}
puts formatter % {first: "one", second: "two", third: "three", fourth: "four"}
puts formatter % {first: true, second: false, third: true, fourth: false}
puts formatter % {
  first: "here's a thing",
  second: "and another thign",
  third: "and yet another",
  fourth: "and one more"
}

# My own example (to show 'formatter' can be anythign):

thing = "%{f} and %{g}"
puts thing % {f: 22, g: 43}



error_message = """
The currency %{currency_code} cannot be found. 
See `Currency.last.blob[\"rates\"].keys` to view 
available currencies. 
"""
from = "AUDz"
error_message % {currency_code: from}
