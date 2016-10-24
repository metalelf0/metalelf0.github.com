---
layout: post
title: "Machinist vs Factory Girl: Machinist win!"
tagline: "leave the DB alone"
category: rails
tags: [db, factorygirl, machinist, rails, rspec, test]
theme:
  name: journal
---

Today I decided to verify if [Machinist](https://github.com/notahat/machinist) could be a good replacement for [Factory Girl](https://github.com/thoughtbot/factory_girl). In our project, we have a big problem with Factory Girl: even if you tell her not to hit the database, using the `Factory.build` method, if an object has associations, these are saved on the DB. And this causes a huge slowdown in specs using factories. We've been using Factory Girl for nearly two years, and if we could find a way to stop him hitting the DB, we could really have a huge improvent in our test suite running time.

To verify if Machinist could perform better, I set up a basic rails app. Look at this example:

<script src="https://gist.github.com/1033984.js"></script>

If you run `tail -f log/test.log` and you run this spec, you'll see something like this:

<script src="https://gist.github.com/1033991.js"> </script>

The `Factory.build` method has to save dependencies on the DB to set the foreign keys on the objects and validate them.

Let's try with machinist:

<script src="https://gist.github.com/1033995.js"> </script>

This time, running tail on the test.log file and running the spec, doesn't shown any DB hit, and of yeah, we have a green test.

I verified this also by putting a `debugger` line after the validation and inspecting the DB from within the debugger after the validation has run - with FactoryGirl, it revealed an `Address` object saved on the DB, while with Mechanist it didn't.

I still haven't looked inside machinist to show how it handles this, but I'll do it soon, so keep in touch!
