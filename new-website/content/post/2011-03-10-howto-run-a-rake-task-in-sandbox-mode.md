---
categories:
- rails
date: "2011-03-10T00:00:00Z"
tagline: And stop messing data
tags:
- rake
- rails
- db
- rollback
- activerecord
theme:
  name: journal
title: Howto run a rake task in sandbox mode
---


If you have a Rails rake task that somehow changes your DB data, but you want to be sure that the DB will be rolled back to its previous state after the rake task has completed, you can simply include this snippet right after your task definition:

<script src="https://gist.github.com/864117.js"> </script>

If you wonder where is this code coming from, it's directly from the rails console code.
