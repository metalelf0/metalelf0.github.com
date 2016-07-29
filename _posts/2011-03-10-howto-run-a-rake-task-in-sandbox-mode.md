---
layout: post
title: "Howto run a rake task in sandbox mode"
tagline: "And stop messing data"
category: rails
tags: [rake, rails, db, rollback, activerecord]
theme:
  name: journal
---
{% include JB/setup %}

If you have a Rails rake task that somehow changes your DB data, but you want to be sure that the DB will be rolled back to its previous state after the rake task has completed, you can simply include this snippet right after your task definition:

<script src="https://gist.github.com/864117.js"> </script>

If you wonder where is this code coming from, it's directly from the rails console code.
