---
title: Rails 3 scopes with HABTM (has and belongs to many) relations
date: "2011-01-28T00:00:00Z"
categories:
- posts
- technical
tags:
- rails
- rails3
- activerecord
- habtm
- scopes
---


There are already many posts about this, but maybe this simple example will help you understand this subject even better.

```ruby
# First model: tag.rb
# note that pomodori is a custom plural for pomodoro

class Tag < ActiveRecord::Base
  has_and_belongs_to_many :pomodori
end

# Second model: pomodoro.rb
# here is how to define a Rails 3 scope through the join table:

class Pomodoro < ActiveRecord::Base
  has_and_belongs_to_many :tags

  scope :by_tag, lambda { |tag_text|
     joins("join pomodori_tags, tags").
     where('pomodori.id = pomodori_tags.pomodoro_id 
            AND pomodori_tags.tag_id = tags.id 
            AND tags.text = ?', tag_text) 
  }
end
```
