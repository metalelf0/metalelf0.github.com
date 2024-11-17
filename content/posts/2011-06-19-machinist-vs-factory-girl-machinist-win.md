---
categories:
- rails
date: "2011-06-19T00:00:00Z"
tagline: leave the DB alone
tags:
- db
- factorygirl
- machinist
- rails
- rspec
- test
theme:
  name: journal
title: 'Machinist vs Factory Girl: Machinist win!'
---


Today I decided to verify if [Machinist](https://github.com/notahat/machinist) could be a good replacement for [Factory Girl](https://github.com/thoughtbot/factory_girl). In our project, we have a big problem with Factory Girl: even if you tell her not to hit the database, using the `Factory.build` method, if an object has associations, these are saved on the DB. And this causes a huge slowdown in specs using factories. We've been using Factory Girl for nearly two years, and if we could find a way to stop him hitting the DB, we could really have a huge improvent in our test suite running time.

To verify if Machinist could perform better, I set up a basic rails app. Look at this example:

```ruby
# person.rb

  validates_presence_of :address

# person_factory.rb

  Factory.define :person do |p|
    p.name   'John'
    p.surname 'Doe'
    p.association :address
  end

# person_spec.rb

it "builds a valid person with factory girl" do
  Factory.build(:person).should be_valid
end
```

If you run `tail -f log/test.log` and you run this spec, you'll see something like this:

```txt
  AREL (0.5ms)  INSERT INTO "addresses" ("country", "planet", "created_at",
"updated_at") VALUES ('Italy', 'Earth', '2011-06-18 16:45:00.268423',
'2011-06-18 16:45:00.268423')
```

The `Factory.build` method has to save dependencies on the DB to set the foreign keys on the objects and validate them.

Let's try with machinist:

```ruby
# person.rb

  validates_presence_of :address

# blueprints.rb

  Person.blueprint do
    name     { "John"       }
    surname  { "Doe"        }
    address  { Address.make }
  end

# person_spec.rb

it "builds a valid person with machinist" do
  Person.make.should be_valid
end
```

This time, running tail on the test.log file and running the spec, doesn't shown any DB hit, and of yeah, we have a green test.

I verified this also by putting a `debugger` line after the validation and inspecting the DB from within the debugger after the validation has run - with FactoryGirl, it revealed an `Address` object saved on the DB, while with Mechanist it didn't.

I still haven't looked inside machinist to show how it handles this, but I'll do it soon, so stay tuned!
