---
layout: post
title: "Command pattern in ruby and rails"
tagline: "wear your refactoring hat!"
category: rails
tags: [rails, ruby, oo, design, hexagonal, hanami]
excerpt_separator: <!--more-->
---
{% include JB/setup %}

### The problem

If you have a growing Rails application and you feel your models are getting too
fat you might have a problem. We've all been educated with the "fat models, thin
controllers" dogma - but sometimes putting all the domain logic inside the
models has its downsides.

As an example, the typical flow of an `ActiveRecord` object through a Rails
request involves:

* fetching the object from the DB based on the params you receive (controller);
* doing something with the object inside the model (model);
* when something goes wrong, you set errors onto the model attributes (model);
* you finally return the object to the view, and present it accordingly (view).

This is gonna tangle a lot of the domain logic to your model (scopes to
retrieve objects, validations, and in the worst case even some presentation
logic).

<!--more-->

### The solutions

You may be tempted at some point to throw it all away and just start over with a
new solution. `@jodosha` is doing a great work with
[Hanami](https://github.com/hanami/hanami), (formerly Lotus), and it's a great
solution that you should consider if you're starting a new project from scratch.
[Trailblazer](https://github.com/apotonick/trailblazer) is another project built
on top of Rails with the aim of decoupling dependencies; however I found its
documentation very lacking compared to the Hanami guides, but I didn't buy their
sponsored book, so YMMV.

Anyway, if your Rails application is already in production, and you can't afford
a full rewrite, there is still hope - wear your refactoring hat and follow me.

I'll show you a little piece of code to introduce a useful pattern:
the command (or use case) pattern. This is gonna help you separating concerns
in your application. Let's take a look at some example code:

{% highlight ruby %}
class MultipleUseCase
  attr_reader :number, dividend

  def initialize(number, dividend)
    @number, @dividend = number, dividend
  end

  def run(success, failure)
    if number % dividend == 0
      success.call(number, dividend)
    else
      failure.call(number, dividend, number % dividend)
    end
  end
end

def fancy_puts(string)
  puts string.upcase!
end

MultipleUseCase.new(267434, 345).run(
  -> (number, dividend)            
      { fancy_puts "#{number} is an exact multiple of #{dividend}" },
  -> (number, dividend, remainder)
      { fancy_puts "#{number} isn't an exact multiple of #{dividend}\
                   (remainder is #{remainder})" }
)
{% endhighlight %}

What we have here is a `MultipleUseCase` class implementing the command pattern.
It has a single public method - `MultipleUseCase#run` - which accepts two
arguments: a success procedure and a failure procedure.

As you see in the last block, we are passing two lambdas as arguments to the
run method; one that will be called on a success scenario, and one that will be
called in a failure scenario. This introduces a clear separation between
domain logic (in the use case) and presentation logic.

The latter, in this example, involves just building a simple string with some
parameter interpolation; but it's not inside the use case object. This allows us
to reuse the use case anywhere and inject any presentation logic we want, like
the `fancy_puts` method defined outside of the use case.

Think about it: when you're unit testing the use case, you can pass a mock
object for each of the functions, and just ensure they are getting called with
the correct parameters; if you are using the logic in a Rails controller, you
can instead use - i.e. - the `format` methods to switch presentation logic
depending on the requested format:

{% highlight ruby %}
# somewhere in a Rails controller

respond_to do |format|
  MultipleUseCase.new(params[:dividend], params[:divisor]).run(
    -> (number, dividend) {
      format.html { ... }
      format.json { ... }
    },
    -> (number, dividend, remainder) {
      format.html { ... }
      format.json { ... }
    }
  )
end

{% endhighlight %}

### What else?

This strategy won't solve all your problems; if you have a lot of dependencies
between AR models, you will still find a lot of framework-dependent code inside
your use cases. If you wanna refactor further, you can consider introducing
Repository objects to wrap all the persistency related logic.

Also, you might decide to extract some reusable logic from the use cases into
Service Objects.

If this is not gonna be enough, well, maybe Rails is not the right tool for your
job. I would suggest taking a look at the other frameworks I mentioned above
instead of trying to force Rails to do something different. A heavily patched
Rails application won't be a Rails application anymore, and it will require a
lot of tinkering to work with any gem built for Rails. Also, any Rails developer
will need to learn how to use "your Rails", instead of just using Rails.
Using a framework like Hanami would be a far better solution, and you could
also contribute to the development of a very promising ruby project.

Let me know what you think and thanks for reading! `:)`
