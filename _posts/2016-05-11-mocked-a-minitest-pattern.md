---
layout: post
title: "Mocked - a minitest pattern"
tagline: "mocking stuff has never been so fun!"
category: rails
tags: [rails, ruby, oo, test, minitest]
theme:
  name: journal
---
{% include JB/setup %}

### Minitest is good for mocking, right? Well...

Minitest is gaining a lot of popularity and can actually be a 100% replacement
for RSpec. It's a pure ruby testing framework, it's fast, light weight, and it
supports both a test-unit like syntax and a spec engine with Rspec like syntax.

Still, when it comes to mocking, it can be a little painful. You have to
initialize mocks and verify them manually after running the code under test.

A typical unit test with mocks looks something like this:

{% highlight ruby %}
test 'a pause can be completed' do
  datetime_service = MiniTest::Mock.new
  pause            = MiniTest::Mock.new
  success          = MiniTest::Mock.new
  failure          = MiniTest::Mock.new
  now = DateTime.now
  datetime_service.expect(:datetime_now, now)
  pause.expect(:completed_at, nil)
  pause.expect(:update_attributes, true, [completed_at: now])
  success.expect(:call, true, ["Pause completed", pause])
  UseCases::Pauses::Complete.new.run(pause, datetime_service, success, failure)
  datetime_service.verify
  failure.verify
  success.verify
  pause.verify
end
{% endhighlight %}

What I don't like in the code above is the verbosity in the setup (and
verification) of mock objects. I'm relying quite heavily on mocks, as I don't
want to pass real objects to my unit tests, and this kind of repetition is not
good.

Also I want to have a way to distinguish mock objects from "real" objects.
This could help seeing if there is too much "real" stuff inside the test, or if
I'm correctly mocking all the dependencies and collaborators of the method under
test.

What I came up with is `Mocked`, a small module to streamline these operations.

{% highlight ruby %}
# test/utils/mocked.rb
module Mocked
  def add_mocks(*names)
    names.each { |name| add_mock(name) }
  end

  def add_mock(name)
    @mocks[name] = MiniTest::Mock.new
  end

  def mocked(name)
    @mocks[name]
  end

  def verify_mocks
    @mocks.each do |_, mock|
      mock.verify
    end
  end

  def setup_mocks
    @mocks = Hash.new
  end
end

# test/test_helper.rb

#...
require 'utils/mocked'
# ...
class ActiveSupport::TestCase
  include Mocked
  setup :setup_mocks
  teardown :verify_mocks
end
{% endhighlight %}

We are just keeping an hash of mock objects, and verifying them on teardown of
the test; we are also giving a `mocked(mock_name)` accessor to retrieve mock
objects.

With this we can rewrite the test above like this:

{% highlight ruby %}
test 'a pause can be completed' do
  add_mocks(:datetime_service, :pause, :success, :failure)
  now = DateTime.now
  mocked(:datetime_service).expect(:datetime_now, now)
  mocked(:pause).expect(:completed_at, nil)
  mocked(:pause).expect(:update_attributes, true, [completed_at: now])
  mocked(:success).expect(:call, true, ["Pause completed", mocked(:pause)])
  UseCases::Pauses::Complete.new.run(
    mocked(:pause),
    mocked(:datetime_service),
    mocked(:success),
    mocked(:failure)
  )
end
{% endhighlight %}

The code looks better IMHO, and I like that if I decided - i.e. - to replace
the `pause` mock with a real object it would read like:

{% highlight ruby %}
test 'a pause can be completed' do
  add_mocks(:datetime_service, :success, :failure)
  now = DateTime.now
  mocked(:datetime_service).expect(:datetime_now, now)
  pause = FactoryGirl.create(:pause, completed_at: nil)
  mocked(:success).expect(:call, true, ["Pause completed", pause])
  UseCases::Pauses::Complete.new.run(
    pause,
    mocked(:datetime_service),
    mocked(:success),
    mocked(:failure)
  )
  assert_equal now, pause.completed_at
end
{% endhighlight %}

Here you can clearly see at a first glance that the only real object is `pause`,
whereas other objects are all mocked. It also really helps when refactoring
tests.

What do you think about this? Would you like to be built into a gem, do you have
any suggestions or criticism on this? Let me know and have a great day!
