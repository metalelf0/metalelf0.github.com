---
title: Howto share Spree authentication/authorization engine
date: "2012-03-02T00:00:00Z"
categories:
- posts
- technical
tags:
- spree
- ruby
- rails
- devise
- cancan
---

In a project I'm working on I'm using spree as a mountable engine. The host application has its own administration area, and I wanted to share the spree authentication with my app.

Spree uses devise to handle authentication. The code which is responsible for the authentication part of the app is in the auth module of Spree.

To share authentication with your application you have to:

* setup devise in your routes.rb file. I copied this code from the routes.rb file included in the spree/auth module:

```ruby
HostApplication::Application.routes.draw do
  devise_for :user,
     :class_name => 'Spree::User',
     :controllers => { :sessions => 'spree/user_sessions',
                       :registrations => 'spree/user_registrations',
                       :passwords => 'spree/user_passwords' },
     :skip => [:unlocks, :omniauth_callbacks],
     :path_names => { :sign_out => 'logout' }
  # ...
end
```

* add `before_filter :authenticate_user!` to the controller you want to be protected.

This way you're setup with authentication; it's time to move on with authorization.

* add `load_and_authorize_resource!` to the controller you want to be protected.

* register new abilities to the Spree CanCan configuration using the `register_ability` method. Here is an example:

```ruby
# create a file in config/initializers, e.g. add_abilities_to_spree.rb,
# with the following content:

Spree::Ability.register_ability MyAppAbility

# create a file under app/models (or lib/) to define your abilities (in
# this example I protect only the HostAppCoolPage model):

class MyAppAbility
  include CanCan::Ability

  def initialize(user)
    if user.has_role?('admin')
      can manage, :host_app_cool_pages
    end
  end
end
```

* add to your `application_controller.rb` file the code needed to handle authorization exceptions:

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_ability
    @current_ability ||= Spree::Ability.new(current_user)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :root, :alert => exception.message
  end
end
```

And you're done!
