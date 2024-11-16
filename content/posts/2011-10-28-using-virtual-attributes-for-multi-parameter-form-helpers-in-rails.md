---
categories:
- rails
date: "2011-10-28T00:00:00Z"
tagline: tricky tricky
tags:
- rails
- ruby
theme:
  name: journal
title: Using virtual attributes for multi parameter form helpers in Rails
---


In a Rails application I am working on, I needed to setup a form with a field with a non-standard behaviour. The field represents a `Date` object, so the `date_select` `FormHelper` looked great; however, the date to display was not the actual date to be set on the database, but the day before. Changing all the data on the DB was a bit risky, so I had to stick with this requirement.
I decided to use a virtual attribute to do this, as it seemed the most elegant solution, so I wrote this in my model:


```ruby
# user_subscription.rb
def expire_date_minus_one_day
  self.expire_date - 1.day
end

def expire_date_minus_one_day= date
  self.expire_date = date + 1.day 
end
```

And this in my view:

```erb
  <p>
    <%= f.label :expire_date %>
    <%= f.date_select :expire_date_minus_one_day %>
  </p>
```

However, trying to send this data to the controller resulted in a "1 error(s) on assignment of multiparameter attributes" error.

The solution I found after some search was this one:

```ruby
# user_subscription.rb
  composed_of :expire_date_minus_one_day,
              :class_name => 'Date',
              :mapping => %w(Date to_s),
              :constructor => Proc.new{ |item| item },
              :converter => Proc.new{ |item| item }
```

Reference:
<a href="http://gabeodess.heroku.com/posts/14">http://gabeodess.heroku.com/posts/14</a>
