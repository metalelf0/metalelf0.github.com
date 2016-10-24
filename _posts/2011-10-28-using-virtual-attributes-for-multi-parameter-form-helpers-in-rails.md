---
layout: post
title: "Using virtual attributes for multi parameter form helpers in Rails"
tagline: "tricky tricky"
category: rails 
tags: [rails, ruby]
theme:
  name: journal
---

In a Rails application I am working on, I needed to setup a form with a field with a non-standard behaviour. The field represents a `Date` object, so the `date_select` `FormHelper` looked great; however, the date to display was not the actual date to be set on the database, but the day before. Changing all the data on the DB was a bit risky, so I had to stick with this requirement.
I decided to use a virtual attribute to do this, as it seemed the most elegant solution, so I wrote this in my model:

<script src="https://gist.github.com/1321926.js"> </script>

And this in my controller:

<script src="https://gist.github.com/1321928.js"> </script>

However, trying to send this data to the controller resulted in a "1 error(s) on assignment of multiparameter attributes" error.

The solution I found after some search was this one:

<script src="https://gist.github.com/1321930.js"> </script>

Reference:
<a href="http://gabeodess.heroku.com/posts/14">http://gabeodess.heroku.com/posts/14</a>
