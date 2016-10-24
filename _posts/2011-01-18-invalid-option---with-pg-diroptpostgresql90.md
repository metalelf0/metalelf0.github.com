---
layout: post
title: "invalid option:   with pg dir=/opt/PostgreSQL/9.0"
tagline: "just need two dashes more"
category: tricks 
tags: [postgresql, ruby, gem, rubygems, pg, tricks, tips]
theme:
  name: journal
---

I'd bet a lot of ruby devs actually found themselves stuck in this problem. You checkout a github repo, you run a bundle install and = duh = a gem cannot install because of a missing library.
You're sure you've already installed the library or dependency or whatever, but in a different path from the standard one (in this example I'm talking about PostgreSQL installed via the graphical installer instead of the ubuntu apt repo); so you issue the command

    gem install pg -v0.9.0 --with-pg-dir=/opt/PostgreSQL/9.0

And you get this error message: 

    invalid option: --with-pg-dir=/opt/PostgreSQL/9.0

What's the problem? You need to separate options with another pair of dashes:

    gem install pg -v0.9.0 -- --with-pg-dir=/opt/PostgreSQL/9.0

And everything will work.
