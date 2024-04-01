


### Phone number best practices

The goal here is to make (however is easiest; e.g. leveraging off community or DIY from scratch) a best practice phone number form (with accompanying controller logic + model/db) that makes it easy to use in a rails app. Basically a super easy way to get best practice for phone input in your rails app (across desktop and mobile).


Tl;dr

- Always ask for the phone number in two fields (international dial code, and the rest of the number)
- Always store international dial code and the rest of the number as two columns in the db
- Use a library for validations (since they're too complex for any sane human to try to regex)

Some auxiliary notes:

- It's okay to use country (string) or flag unicode character to prepopulate the international dial code, but always allow the user to edit the international dial code to what they think it should be, irrespective of the country/flag they entered
    - This is because you can't assume an international dial code implies a country (e.g. +1 could mean US, Canada, or Islands), nor that a country implies a dial code.
  - If you have any interest at all in storing the user's country(/flag), don't assume the international dial code is enough; also store the country/flag (can store the unicode character) the user entered too (for the reason mentioned above; if you saw +1 you couldn't tell if they're US, Canadian etc).
