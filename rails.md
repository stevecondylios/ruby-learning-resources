

This may become its own repo. For now including in ruby-learning-resources


The purpose is to collect rails tid-bits that will serve as a useful reminder for anyone forgetful. 


things to include: fixtures, factories, testing (defaults, but also with RSpec). 


# Intro

- The average rails app has 1.03 lines of test code for every line of code in the app! [Source](https://semaphoreci.com/blog/2018/04/11/state-of-testing-in-rails.html)



# Important resources

- How to look up rails documentation: [api.rubyonrails.org](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/Table.html#method-i-timestamps) - **use the search bar on top left**
- [Rails guides](https://guides.rubyonrails.org/) (these aren't 'read once and forget' - experienced devs use them daily)


# How to setup your working environment (IDE, terminal etc)

- Great video on vscode extensions [here](https://www.youtube.com/watch?v=VXTmd-4jx8g)



# Notes from [Rails 7 demo](https://www.youtube.com/watch?v=mpWFrUwAN88)

- `.deliver_later` knows to run inline in development, and for it to work properly (i.e. asynchonously) in production, it requires some setup of (??) 
- Rich text fields
- 





# Rails environments: test / dev / prod

- `rails console` will get you the rails console. `RAILS_ENV=test rails c` will open the rails console in test mode! 
  - Similarly, to reset the test database: `RAILS_ENV=test rails db:reset`




# Views




### How to display errors in the view (e.g. after a form validation error)

- Controller re-renders new View when model fails to save

e.g.

```rb
  if @simulation.save
    redirect_to action: 'index'
  else
    render 'new'
  end
```

Since it's using render, that will send the same model instance back to the view, and it will at that stage have errors, hence the code at the top of the scaffold will run. E.g. something like this:


```erb
<%= form_with(model: report) do |form| %>
  <% if report.errors.any? %>
    <div style="color: red">
      <h2><%= pluralize(report.errors.count, "error") %> prohibited this report from being saved:</h2>

      <ul>
        <% report.errors.each do |error| %>
          <li><%= error.full_message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>
```

Note, I'm pretty sure you can roll your own mechanism, just create something like `@errors` in the controller, and some logic to display it in the view. 


### How to make flash messages in the view 

Reading:

- [SO: How to show error message on rails views?](https://stackoverflow.com/a/31092957/5783745)
- [Flash Messages](https://www.rubyguides.com/2019/11/rails-flash-messages/)
  - The flash object has methods like `keys`, `any?` or `each` & you can access a particular message with `[]`.

By default you have `notice` and `alart`, e.g.:

```rb
flash.alert = "User not found."
```

or like this

```rb
redirect_to :books_path, notice: "Book not found"
```

And to render the flash messages:

```
<% flash.each do |type, msg| %>
  <div class="alert alert-info">
    <%= msg %>
  </div>
<% end %>
```

Keep in mind:

- If you redirect_to, then render a flash message, that???s good
- If you redirect_to & DON???T render the message, the message will stick around, in the flash hash
- If you render on the same action that you???re setting the flash message, that flash message will be available, but NOT removed so it will stay around & potentially be shown twice



When using render, you may wish to use `flash.now` to render on the *current* action:

```rb
# In controller
flash.now[:notice] = "We have exactly #{@books.size} books available."
```







# Model associations

Know the [3 big ones](https://www.youtube.com/watch?v=nZNfSQKC-Yk&t=880s) well: 

- has_many 
- belongs_to
- has_many :through



### has_and_belongs_to_many


[This](https://www.youtube.com/watch?v=rbpye74Wt2o) video says: 

> Don't use (has_and_belongs_to_many) when you need validations, callbacks, or extra attributes on the join model

(but I suspect by 'join model' it means the little model rails sets up *inbetween* the two models connected by has_and_belongs_to_many, so I think has_and_belongs_to_many should still be fine for my purposes)


- A 'Join Table' is just a table that has two columns, model1_id, and model2_id, that way for a given model1_id you can see all the model2_ids, and vice-verse. I.e. allowing a many to many relationship. 

Resources on HABTM:
- Great diagram [here](https://stackoverflow.com/questions/34565148/what-is-the-use-of-join-table-in-rails#comment127295361_34565307) (3rd/last diagram)
- How to create a HABTM migration [here](https://stackoverflow.com/a/5917599/5783745)
- Note that the join table should be defined ***alphabetically*** (see [here](https://apidock.com/rails/v6.1.3.1/ActiveRecord/Associations/ClassMethods/has_and_belongs_to_many)):

> Developer and Project will give the default join table name of ???developers_projects??? because ???D??? precedes ???P??? alphabetically

- Rails Guide on [HABTM](https://guides.rubyonrails.org/association_basics.html#the-has-and-belongs-to-many-association) is really good. 

- How to create a join table, see [here](https://guides.rubyonrails.org/active_record_migrations.html#creating-a-join-table)


Note that for uuid in the join table, need the extra parameter in the migration:

```rb
    create_join_table :landlords, :properties, column_options: {type: :uuid} do |t|
      t.index [:landlord_id, :property_id]
      t.index [:property_id, :landlord_id]
    end
```

How to create records in the join table

```rb

Landlord.first.properties << Property.first
Landlord.first.properties

# Note that nothing stops duplicates. 

```

Note that `Landlord.first.properties.first.destory` would delete **the actual property** record. To remove just the *association* (not the object), use [this](https://stackoverflow.com/a/21279265/5783745) method (untested by me).





# Scopes


> Scopes are custom queries that you define inside your Rails models with the scope method. From [here](https://www.rubyguides.com/2019/10/scopes-in-ruby-on-rails/)


In your controller you might want to only show published posts: 

```ruby

def index

  @posts = Post.all.where(status: "Published")

end
```

Another (more elegant) way to do this is jumping into your Post model and creating a scope (the `scope` method appears to accept 2 arguments, a name for the scope, and a lambda that contains the code for the scope), such that:


```ruby

scope :published, -> { where(status: "Published") }

```

Then in your controller you can have this:


```ruby

@posts = Post.published

```

And it will do the exact same thing. 

So TL;DR scopes are a great way to keep controller code DRY, and move some controller code into the model. 


**A note on default scopes** - [Don't use default scopes!](https://piechowski.io/post/why-is-default-scope-bad-rails/) - The case for not using default scopes is strong: they look convenient, but really just mess with your queries - steer well clear. `default_scope`s  tend to [make a massive mess](https://stackoverflow.com/questions/25087336/why-is-using-the-rails-default-scope-often-recommend-against)!. 















# Testing 

- Awesome [rails guide on testing](https://guides.rubyonrails.org/testing.html)
  - It covers **unit**, **functional**, **integration**, and **system** tests
- Nice reinteractive [article](https://reinteractive.com/posts/342-what-constitutes-good-testing-in-rails) on what constitutes good testing
- JS article on the specific kinds of tests he uses in a rails app ([here](https://www.codewithjason.com/set-rails-application-testing/))


The purpose of testing is to:

> ensure your code adheres to the desired functionality even after some major code refactoring.

> Rails tests can also simulate browser requests and thus you can test your application's response without having to test it through your browser.


### Types of tests

The rails guide [introduces 4 types of tests](https://guides.rubyonrails.org/testing.html):

> How to write unit, functional, integration, and system tests for your application.

1. Unit tests 
  - e.g. testing minute details in a methods inputs/outputs
  - A unit test is about testing a single function/method in isolation with all of its possible outputs. ([source](https://developers.forem.com/tests/unit-functional-tests))
2. [Functional tests](https://guides.rubyonrails.org/testing.html#functional-tests-for-your-controllers) (AKA Controller Tests)
  - 'testing that controllers and models are using the mailer in the right way'
  - A functional test is about testing a single functionality, which can span multiple methods and a controller. Other common terms in Rails are "model tests," "controller tests," and others. ([source](https://developers.forem.com/tests/unit-functional-tests))
  - SC thinking: Based on the examples I see in a MRE test rails app, I *think* controller tests test things like whether a GET/POST/PATCH/DELETE to a certain url works, whether a new record is created/deleted in the right table, and whether any redirect occurs as expected. 
    - But note (from [rails guide](https://guides.rubyonrails.org/testing.html#available-request-types-for-functional-tests)): 
    > Functional tests do not verify whether the specified request type is accepted by the action, we're more concerned with the result. Request tests exist for this use case to make your tests more purposeful.
    - Also note under 'functional tests' (aka controller tests) the [rails guide](https://guides.rubyonrails.org/testing.html#putting-it-together) gives an example of a test that reloads the fixure after a PATCH, and checks that the new attribute was indeed updated as expected. 
    - Note that Rspec recommends not doing controller tests (since around 2018), and now recommends [request tests](https://medium.com/just-tech/rspec-controller-or-request-specs-d93ef563ef11) which are like integration tests and route tests conbined. 
3. Integration tests
  - Integration tests are used to test how various parts of our application interact. They are generally used to test important workflows within our application. ([source](https://guides.rubyonrails.org/testing.html#integration-testing))
  - An integration test is a test that measures the interaction of multiple systems or parts of your application. ([source](https://developers.forem.com/tests/integration-tests))
4. System tests ([AKA **acceptance tests**, **feature tests**](https://developers.forem.com/tests/acceptance-tests#:~:text=Acceptance%20tests%20are%20tests%20from,actions%20inside%20of%20our%20tests.&text=Acceptance%20tests%20can%20be%20found%20in%20the%20directory%20spec%2Fsystem%20.))
  - Great practical [video](https://www.youtube.com/watch?v=QNZt7FCVYro) to get started quickly. 
  - Might use capibara (a ruby tool for managing selenium) to visit a certain route, and see if it can see what it expects on the page (see great example [here](https://www.youtube.com/watch?v=ZPcRiPrpQTc))
  - System tests allow you to test user interactions with your application, running tests in either a real or a headless browser. System tests use Capybara under the hood. ([source](https://guides.rubyonrails.org/testing.html#system-testing))
  - Good thoughtbot cheatsheet on accepting testing in Rspec [here](https://thoughtbot.com/upcase/test-driven-rails-resources/rspec_acceptance.pdf) which uses `feature` and `scenario` e.g. (feature 'Signing in' do
  scenario 'signs the user in successfully with a valid email and password')
  - SC thinking: I *think* system tests use a browser and simulate mouse clicks, then check if the next page has what we expect on it. I think the distinguishing characteristic of system tests is that system tests are confirming what's going on *from the user's perspective*, that is, based on things a user would do, and based on what a user would see. 

Other notes: 

- Acceptance tests are also known as Feature tests or System tests. ([source](https://developers.forem.com/tests/acceptance-tests#:~:text=Acceptance%20tests%20are%20tests%20from,actions%20inside%20of%20our%20tests.&text=Acceptance%20tests%20can%20be%20found%20in%20the%20directory%20spec%2Fsystem%20.))

On mailer tests: 

> There are two aspects of testing your mailer, the **unit tests** and the **functional tests**. In the unit tests, you run the mailer in isolation with tightly controlled inputs and compare the output to a known value (a fixture). In the functional tests you don't so much test the minute details produced by the mailer; instead, we test that our controllers and models are using the mailer in the right way. You test to prove that the right email was sent at the right time.

> Functional tests do not verify whether the specified request type is accepted by the action, we're more concerned with the result. Request tests exist for this use case to make your tests more purposeful. ([source](https://guides.rubyonrails.org/testing.html#available-request-types-for-functional-tests))


### What is acceptance testing? 

From top of google [results](https://developers.forem.com/tests/acceptance-tests#:~:text=Acceptance%20tests%20are%20tests%20from,actions%20inside%20of%20our%20tests.&text=Acceptance%20tests%20can%20be%20found%20in%20the%20directory%20spec%2Fsystem%20.): 

> **Acceptance tests are tests from the perspective of the end-user**. In the Rails world, we sometimes refer to these as **Feature tests** or **System tests**. A tool called Capybara is included to help us simulate a human's actions inside of our tests.

From the [RSpec cheat sheet on acceptance tests](https://thoughtbot.com/upcase/test-driven-rails-resources/rspec_acceptance.pdf). Very elucidating example [here](https://thoughtbot.com/upcase/test-driven-rails-resources/rspec_acceptance.pdf). 


From Jason K: 

> You might have an acceptance test to make sure that when that route is visited, the db is 'fixtured up' and something displayed in the view

From Jason S ([here](https://www.codewithjason.com/set-rails-application-testing/)):

> Capybara is a tool for writing acceptance tests, i.e. tests that interact with the browser and simulate clicks and keystrokes. The underlying tool that allows us to simulate user input in the browser is called Selenium. Capybara allows us to control Selenium using Ruby.

- Brilliant hello world example video [here](https://www.youtube.com/watch?v=ZPcRiPrpQTc)



### Quick tips on testing

From reinteractive's [article](https://reinteractive.com/posts/342-what-constitutes-good-testing-in-rails):

- What's the best framework? Ruby has minitest and Rspec; both are great, just be sure to use a framework - don't go writing your own DSL or doing testing in raw ruby code. 

Testing in essence:

> you want to check if something returns the expected results for a known input


**On TDD**

> I am personally not a hardcore fan of any of those camps. Sometimes I write the test before I write the actual code. However, there are also times when I write the code first and then the test. The important part is that I have a test for my new feature. Whether you write the test before or after doesn't really matter, as long as it is there by the time you push your code to review and merge it to the main codebase.


To what extent should you test? 

Author: 

> I'll test the 'happy path' (both arguments provided), possible error paths (e.g. both arguments `nil`), and with one argument as `nil`. 

It would look like this:

```ruby
def full_name
  "#{first_name} #{last_name}".strip 
end

describe "#full_name" do
  let(:user) { User.new(first_name: first_name, last_name: last_name) }

  context "with first name and last name" do
    let!(:first_name) { 'sylvester' }
    let!(:last_name) { 'stallone' }

    it "shows the full name" do
      expect(user.full_name).to eq('sylvester stallone')
    end
  end

  context "when both first and last names are nil" do
    let!(:first_name) { nil }
    let!(:last_name) { nil }

    it "shows the full name" do
      expect(user.full_name).to eq('')
    end
  end

  context "when only one name is present" do
    let!(:first_name) { 'sylvester' }
    let!(:last_name) { nil }

    it "shows the full name" do
      expect(user.full_name).to eq('sylvester')
    end
  end
end
```

> If it's not critical code, test the 'happy path', the worst case scenario, and one other test. 


Don't test frameworks/libraries (trust their maintainers and the community to do that).

**Validation tests**

Use [shoulda gem](https://github.com/thoughtbot/shoulda) (some more examples [here](https://github.com/thoughtbot/shoulda#overview)):


```ruby
# spec/models/user_spec.rb
 describe '#validations' do
   it { should validate_presence_of(:first_name) }
 end
```

**Example of testing that data got stored in database correctly** (from [rails guide](https://guides.rubyonrails.org/testing.html#putting-it-together)):

```rb
test "should update article" do
  article = articles(:one)

  patch article_url(article), params: { article: { title: "updated" } }

  assert_redirected_to article_path(article)
  # Reload association to fetch updated data and assert that title is updated.
  article.reload
  assert_equal "updated", article.title
end
```


Always write readable tests: 

> Tests usually serve as documentation for your code. Try to write them in a way that someone can understand the intention of the code simply by reading your tests.

> with an existing project, the first thing most of us will do is to run the test suite to see if it passes.


You can run `rspec spec --format documentation` to print the documentation when running tests. It's good practice to use the documentation command above to check whether your spec is readable.


**System tests use Capybara**

- System tests (those with an automated browswer simulating user clicks etc) [use capybara](https://guides.rubyonrails.org/v5.1/testing.html#system-testing) under the hood.
- Capybara docs: https://github.com/teamcapybara/capybara#setup
- Capybara methods (like `click_on`, `fill_in` and `assert_text`): https://github.com/teamcapybara/capybara#the-dsl




### My quick notes on capybara

- Capybara comes with a new rails app, enables browser automation for systems tests
  - You can get it to do pretty much anything you'd expect with browser automation: easily find elements on the page and click on them, enter info into forms etc
- Capybara quick and dirty docs at their readme: https://github.com/teamcapybara/capybara#the-dsl
- And more complete reference: https://rubydoc.info/github/teamcapybara/capybara/master

Some random examples to explore (form [Capybara docs](https://github.com/teamcapybara/capybara#clicking-links-and-buttons)):

```rb
click_link('id-of-link')
click_link('Link Text')
click_button('Save')
click_on('Link Text') # clicks on either links or buttons
click_on('Button Value')
```

Querying (AKA selecting elements on the page, a bit like javascript's `document.querySelector()`/`document.querySelectorAll()`):

```rb
page.has_selector?('table tr')
page.has_selector?(:xpath, './/table/tr')

page.has_xpath?('.//table/tr')
page.has_css?('table tr.foo')
page.has_content?('foo')
```



Interacting with forms:

```rb
fill_in('First Name', with: 'John')
fill_in('Password', with: 'Seekrit')
fill_in('Description', with: 'Really Long Text...')
choose('A Radio Button')
check('A Checkbox')
uncheck('A Checkbox')
attach_file('Image', '/path/to/image.jpg')
select('Option', from: 'Select Box')
```

And a LOT more (check the [readme](https://github.com/teamcapybara/capybara)).



### Nice example of GitHub Action for CI to run RSpec tests for rails 7 app (postgres db)

- See CE readme for more. 

```yaml
# .github/workflows/main.yml
name: CI
on:

  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    services: 
      postgres:
        image: postgres:10.8
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: ""
          POSTGRES_DB: postgres
        ports:
          - 5432:5432
        # needed because the postgres container does not provide a healthcheck
        # tmpfs makes DB faster by using RAM
        options: >-
          --mount type=tmpfs,destination=/var/lib/postgresql/data
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    env:
      RAILS_MASTER_KEY: ${{ secrets.RAILS_MASTER_KEY }} # Sc: https://stackoverflow.com/a/69242971/5783745
      PGHOST: localhost
      PGUSER: postgres
      # Rails verifies the time zone in DB is the same as the time zone of the Rails app
      TZ: "Australia/Melbourne"

    steps:

      - uses: actions/checkout@v2

      # SC: guess based on docs: https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions
      - name: Install libvips
        run: sudo apt-get install -y libvips

      - name: Setup Ruby
        uses: ruby/setup-ruby@v1.111.0
        with:
          ruby-version: 3.0.3

      - uses: Borales/actions-yarn@v3
        with:
          cmd: install

      - name: Install Dependencies
        run: |
          sudo apt install -yqq libpq-dev
          gem install bundler
      - name: Install Gems
        run: |
          bundle install
      - name: Setup database
        env:
          PG_DATABASE: postgres
          PG_HOST: localhost
          PG_USER: postgres
          PG_PASSWORD: password
          RAILS_ENV: test
          WITH_COVERAGE: true
          DISABLE_SPRING: 1
        run: |
          bundle exec rails db:prepare
          bundle exec rake assets:precompile # <-- needed this for rails 7 with esbuild (default js bundling)
      - name: Build and test with rspec
        env:
          PG_DATABASE: postgres
          PG_HOST: localhost
          PG_USER: postgres
          PG_PASSWORD: password
          RAILS_ENV: test
        run: |
          bundle exec rspec spec
      - name: Create Coverage Artifact
        uses: actions/upload-artifact@v2
        with:
          name: code-coverage
          path: coverage/
```







## RSpec

- To run RSpec tests, simply: `bundle exec rspec` (or simply `rspec`)
- What does `let` do? `let` simply creates a variable [but it lazy evaluates it](https://pololu.github.io/rpicsim/file.IntroductionToRSpec.html#label-Let+variables), in other words, it only evaluates it when the variable is actually used. I'm pretty sure it memoizes (which is approximately equal to 'caches') it too, so it's kinda 'made once, used many times' rather than being recreated over and over. 
- It looks like when you [install and setup Rspec](https://semaphoreci.com/community/tutorials/getting-started-with-rspec) it creates a /spec directory. I *think* everything inside it will get run automatically as part of RSpec tests, so long as it ends in `_spec.rb` (a file I created that ended in `_helper.rb` did *not* get run). 
- To remove records from the test database between test runs, see [here](https://github.com/DatabaseCleaner/database_cleaner#rspec-example)


A few notes about organising RSpec tests:

- After setting up RSpec, any new scaffolds will automatically set up RSpec tests (a la 'reviews' tests in HW app). 
- The scaffold will also generate 'routes' tests - by default testing all 7 controller actions (and update via PUT and PATCH). 
- As for controller tests? (there's no directory for those). From rorlink: "You should use requests specs instead of controllers. Request specs tests all from routes, to actions and rendering.". Also confirmed [here](https://medium.com/just-tech/rspec-controller-or-request-specs-d93ef563ef11)
- Similarlly helpers/ directory is to test the helpers in your app. (see Rspec docs [here](https://relishapp.com/rspec/rspec-rails/v/5-0/docs/helper-specs/helper-spec))


Setting up a test:

- I *think* each test file should have `require 'rails_helper'` otherwise the helpers (and even something like `binding.pry`) will not be accessible from rspec tests. 


## Factories and Fixtures

From [here](https://stackoverflow.com/questions/7786207/whats-the-difference-between-a-fixture-and-a-factory-in-my-unit-tests):

<blockquote>
  A Fixture is "the fixed state used as a baseline for running tests in software testing"
  A Factory is "an object for creating other objects"
</blockquote>


From [rails guide on testing](https://guides.rubyonrails.org/testing.html#what-are-fixtures-questionmark):

> What are fixtures? **Fixtures is a fancy word for sample data**. Fixtures allow you to populate your testing database with predefined data before your tests run. Fixtures are database independent and written in YAML. There is one file per model.


> YAML-formatted fixtures are a human-friendly way to describe your sample data.


Example:

```yaml
# lo & behold! I am a YAML comment!
david:
  name: David Heinemeier Hansson
  birthday: 1979-10-15
  profession: Systems development

steve:
  name: Steve Ross Kellock
  birthday: 1974-09-27
  profession: guy with keyboard
```


### Faker


Allows us to change this:

```ruby
FactoryBot.define do
  factory :customer do
    first_name { "MyString" }
    last_name { "MyString" }
    email { "MyString" }
  end
end
```

to this: 

```ruby
FactoryBot.define do
  factory :customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
  end
end
```

That solves the problem of any unique constraints we have in the db (e.g. 'email' field might have the requirement that it's unique). Example from [here](https://www.codewithjason.com/set-rails-application-testing/). 










# Summary of notes from Agile Web Development with Rails 5


How to think of classes and objects in an object oriented language like ruby: 

> When you write object-oriented code, you're normally looking to model concepts from the real world. Typically, during this modelling process you discover categories of thinks that need to be represented. In an online  store, the concept of a line item could be such a category. In Ruby, you'd define a *class* to represent each of these categories. You then use this class as a kind of factory that generates *objects* - instances of that class. An object is a combination of state (for example, the quantity and the product ID) and methods that use the state (perhaps a method to calculate the line the line item's total cost. (p47)

- You create objects by calling a *constructor*, a special method associated with a class. The standard constructor is called `new()`. 
- You invoke methods by sending a message to an object. The message contains the method's name, along with any parameters the method may need. 
- Rails uses *symbols* to identify things. In particular, it uses them as keys when naming method parameters and looking things up in hashes. 
  - A symbol looks like a variable name, but it's prefixed with a colon. You can think of symbols as string literals magically made into constants. Alternatively, you can consider the colon to mean *thing named*, so `:id` is the thing named `id`. 





# Upgrading a ruby or rails version


**General resources**:

- Railsdiff (explained [here](https://www.youtube.com/watch?v=ljgmjoIv4Y8&t=5m46s), link [here](https://railsdiff.org/)) - use it when upgrading from one rails version to another.




**General notes**


- [This walkthrough](https://satchel.works/@wclittle/how-to-upgrade-ruby-versions-within-your-ruby-on-rails-app) suggests running `yarn upgrade` to upgrade javascript packages after you finish updating gems. 
- You can delete `yarn.lock` and `node_modules/` and run `yarn install` to grab javascript packages. 
- Run `node --version` to see the node version. 






**Notes on upgrading from ruby 2.x.x to 3.x.x**:

- When upgrading from ruby 2 to 3, upgrade to the latest 2.x version first, then run tests and play around with the app for a while. The main difference between 2 and 3 is positional vs keyword arguments. The latest patch of 2.x (2.7) warns where there could be a change in behaviour. Hence why going to 2.7 first is a good idea. From [here](https://reinteractive.com/posts/499-no-app-left-behind-upgrade-your-application-to-ruby-3-0-and-stay-on-the-upgrade-path)

- [Ruby-lang notes](https://www.ruby-lang.org/en/news/2019/12/12/separation-of-positional-and-keyword-arguments-in-ruby-3-0/) on positional vs keyword arguments when going to ruby 3.x.x.







**Workflow notes**:

From [here](https://makandracards.com/makandra/59328-how-to-upgrade-rails-workflow-advice):

- Do a separate step for each major Rails version (A). So, if you want to upgrade from Rails 3 to 5, I would do it in two steps 3.x -> 4.2 -> 5.2. [Here](https://makandracards.com/makandra/59328-how-to-upgrade-rails-workflow-advice#section-workflow-for-each-major-rails-upgrade-a) is a workflow for going from one major rails version to another. 
- From [rails guides](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#the-upgrade-process): When changing Rails versions, it's best to move slowly, one minor version at a time, in order to make good use of the deprecation warnings. Rails version numbers are in the form Major.Minor.Patch.
  - Upgrade your gems together with Rails if possible.
- Upgrade Ruby in a separate step.
- If your code base is very large you might need to go in smaller increments.




An **example workflow** from rails 6.0.4.4 / ruby 2.7.1 could look like: 

0. Make sure you have good test coverage!
1. Upgrade to rails 6.1.4.4 
2. Upgrade to rails 7 (note that "Rails 7 requires Ruby 2.7.0 or newer" ([here](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html))). Note [steps](https://stackoverflow.com/a/71112586/5783745) for dealing with webpacker when upgrading to rails 7 (more [here](https://docs.google.com/document/d/1jQn7EP3N53c55p601bgnxw5HO8jMLXhu0EDZCW6SWmQ/edit#).
3. Upgrade to ruby 3.x.x
4. Migrate to hotwire from UJS/Turbolinks. DK: Keep your browser's console up as you're working through this. You'll uncover a bunch of "hidden" issues.
5. keep webpack for the time being. migrate to esbuild (or whatever) as a second step.
6. move to cssbundling








# Generators

- Great way to see available options [here](https://rails.help/g/model). 





