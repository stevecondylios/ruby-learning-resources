


Setup 


```ruby
key = ENV["OPENAI_API_KEY"] 

require "openai"

OpenAI.configure do |config|
    config.access_token = key 
end

client = OpenAI::Client.new
```


# Models


```ruby

# All models info 
client.models.list

# Just the names of models - there are quite a few
client.models.list["data"].map{ |item| item["id"] }

# Look for any containing the substring "gpt" (case insensitive)
client.models.list["data"].map{ |item| item["id"] }.select { |item| item.downcase.include? "gpt" }
# => ["gpt-3.5-turbo", "gpt-3.5-turbo-0301"]
```

So we probably want "gpt-3.5-turbo" or "gpt-3.5-turbo-0301" (ideally GPT 4)


Anyway, lets try it:


```ruby

response = client.chat(
    parameters: {
        model: "gpt-3.5-turbo", 
        messages: [{ role: "user", content: "Hello!"}], 
        temperature: 0.7,
    })
puts response.dig("choices", 0, "message", "content")

```

And again: 

```ruby
response = client.chat(
    parameters: {
        model: "gpt-3.5-turbo", 
        messages: [{ role: "user", content: "What's the capital of Australia?"}], 
        temperature: 0.7,
    })
puts response.dig("choices", 0, "message", "content")
```



This time streaming the response (from the ruby gem [docs](https://github.com/alexrudall/ruby-openai#streaming-chatgpt)) 


```

client.chat(
    parameters: {
        model: "gpt-3.5-turbo", # Required.
        messages: [{ role: "user", content: "Describe a character called Anna!"}], # Required.
        temperature: 0.7,
        stream: proc do |chunk, _bytesize|
            print chunk.dig("choices", 0, "delta", "content")
        end
    })

```





### Example of sending multiple messages from the same chat



Attempt with mulitple previous questions (example messages from [here](https://platform.openai.com/docs/guides/gpt/chat-completions-api)): 


```rb

messages = [{"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Who won the world series in 2020?"},
        {"role": "assistant", "content": "The Los Angeles Dodgers won the World Series in 2020."},
        {"role": "user", "content": "Where was it played?"}]

response = client.chat(
    parameters: {
        model: "gpt-3.5-turbo", 
        messages: messages, 
        temperature: 0.7,
    })
puts response.dig("choices", 0, "message", "content")
# The 2020 World Series was played at Globe Life Field in Arlington, Texas.

```


















