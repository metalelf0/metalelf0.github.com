---
layout: post
title: "Howto share Spree authentication/authorization engine"
tagline: ""
category: rails
tags: [spree, ruby, rails, devise, cancan]
theme:
  name: journal
---

In a project I'm working on I'm using spree as a mountable engine. The
host application has its own administration area, and I wanted to share
the spree authentication with my app.

Spree uses devise to handle authentication. The code which is
responsible for the authentication part of the app is in the auth module
of Spree.

To share authentication with your application you have to:

* setup devise in your routes.rb file. I copied this code from the
  routes.rb file included in the spree/auth module:

<script src="https://gist.github.com/1956909.js"> </script>

* add `before_filter :authenticate_user!` to the controller you want to
  be protected.

This way you're setup with authentication; it's time to move on with
authorization.

* add `load_and_authorize_resource!` to the controller you want to be protected.

* register new abilities to the Spree CanCan configuration using the
  `register_ability` method. Here is an example:

<script src="https://gist.github.com/1957141.js"> </script>

* add to your `application_controller.rb` file the code needed to handle
  authorization exceptions:

<script src="https://gist.github.com/1957179.js"> </script>

And you're done!
