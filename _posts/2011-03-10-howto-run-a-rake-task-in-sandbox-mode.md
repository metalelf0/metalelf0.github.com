---
title: Howto run a rake task in sandbox mode
date: "2011-03-10T00:00:00Z"
categories:
- posts
- technical
tags:
- rake
- rails
- db
- rollback
- activerecord
---

If you have a Rails rake task that somehow changes your DB data, but you want to be sure that the DB will be rolled back to its previous state after the rake task has completed, you can simply include this snippet right after your task definition:

```ruby
ActiveRecord::Base.connection.increment_open_transactions
ActiveRecord::Base.connection.begin_db_transaction
at_exit do
   ActiveRecord::Base.connection.rollback_db_transaction
   ActiveRecord::Base.connection.decrement_open_transactions
end
```

If you wonder where is this code coming from, it's directly from the rails console code.
