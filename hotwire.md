


### Resources

- Great drifting ruby intro video [here](https://www.youtube.com/watch?v=cVKRSF2Td7E&t=11m40s) (looks at turbo frames and some simple stimulus)
- Awesome video making a messages index view with form update with hotwire (turbo stream) [here](https://www.youtube.com/watch?v=csvaYIaBYpw) (especially the first 10 mins or so)
- This (https://github.com/thoughtbot/hotwire-example-template) repo has a bunch of hotwire examples (each branch is a separate example, check the readme for more). 
- This tutorial is extremely highly recommended: https://www.hotrails.dev/turbo-rails


### Random notes

- What's the difference between a [broadcast]() (as per the rails 7 demo video) and turbo_stream from the controller? 
  - ANS: use a broadcast when you want every browser with a certain page (e.g. multiple users with that particular page open) to receive an update. Regular turbo stream will update the *one* browser (i.e. the user's browser). 

- Hotwire is said to be (approximately) the sum of turbodrive, turobframes, turbostreams, and some stimulus. 
  - But IMO, it's better charactised as:
    - Turboframes, which replace some specific dom element, typically a <div> 
    - Turbostreams, which are executed from the controller, and tell the page to update various element(s) without a full page reload
    - Turbostreams broadcasts, which update all open browsers with affected streams (not just one user who makes a request as per regular turbostreams)  

- Every rails 7+ app comes with app/javascript/controllers/hello_controller.js
- According to [here](https://railsnotes.xyz/blog/your-first-stimulus-controller-learn-stimulus-ruby-on-rails-by-building-a-toggle-beginners-guide), stimulus works very well with tailwind. 





# Stimulus

- Nice (very simple) tutorial [here](https://railsnotes.xyz/blog/your-first-stimulus-controller-learn-stimulus-ruby-on-rails-by-building-a-toggle-beginners-guide)
  - From [here](https://news.ycombinator.com/item?id=36486918)


- Setting `application.debug = true` inside app/javascript/controllers/application.js will give more info in the 'console' tab of the chrome javascript console (from [here](https://railsnotes.xyz/blog/your-first-stimulus-controller-learn-stimulus-ruby-on-rails-by-building-a-toggle-beginners-guide) 


















