---
layout: post
title: "Null objects in Rails"
tagline: "a clean way"
category: rails
tags: [rails, ruby, oo, design]
theme:
  name: journal
---
{% include JB/setup %}

### The problem

Recently I've seen in a project I work on a lot of occurrences of this code:

{% highlight ruby %}
if user.privacy && user.privacy.enables_page?(...)
{% endhighlight %}

The first part of the condition above is a bad practice in object oriented
design. It forces collaborators of `user` to know a part of its implementation
- it could have a `privacy` or it couldn't.

### What we want

Wouldn't it be much better to just write this:

{% highlight ruby %}
if user.privacy.enables_page?(...)
{% endhighlight %}

Hiding the responsibility inside the user class? It would be much cleaner and
follow the __Tell, don't ask__ principle.

### How to get there

There are many ways to achieve this behaviour, but most of them will be based
on [__The null object
pattern__](http://en.wikipedia.org/wiki/Null_Object_pattern). We want
`user.privacy` to return an object which responds _falsey_ to all the method of
the original `Privacy` class.

#### First solution

A trivial implementation could look like this:

{% highlight ruby %}
# null_privacy.rb

class NullPrivacy

  def enables_page? any_page
    false
  end

end
{% endhighlight %}

But how we are going to tie this class to our `User` class? Strategies may
change depending on your persistence layer. A one-fits-all solution is this:
build an abstraction layer around your `user.privacy` relation.

{% highlight ruby %}
# user.rb

  has_one :_privacy

  def privacy
    _privacy || NullPrivacy.new
  end

  def privacy= privacy
    self._privacy = privacy
  end
{% endhighlight %}

What we're doing here is renaming the original `privacy` field to `_privacy`,
so that we won't call it directly, and we're building two accessor methods to
use `User#privacy` and `User#privacy=` as usual.

#### Another solution

If you want to keep things even simpler, you can model your `Privacy` class so
that a new instance of this class behaves exactly like a `NullPrivacy`, and
thus avoid the need of a `NullPrivacy`. Just keep in mind that things could
change in your code in the future, so nail this down with a test before
proceeding to avoid nasty surprises in the future.

#### ... and Mongoid

Finally, if you are using `Mongoid` and you can model your `Privacy` class as
described above, there's a one-line solution:

{% highlight ruby %}
  # user.rb

  has_one :privacy, autobuild: true
{% endhighlight %}




