---
categories:
- ruby
date: "2010-04-23T00:00:00Z"
tagline: Hardcore ruby for hardcore people
tags:
- examples
- metaprogramming
- mixin
- ruby
- monkey-patching
theme:
  name: journal
title: Ruby Mixin and monkey patching examples
---


Let's explore a couple of solutions to dynamically add a `split_by_half` behaviour to an array object. The first technique is the <a href="http://en.wikipedia.org/wiki/Mixin">mixin</a>: it allows to add the method to a single array instance. The second one is called <a href="http://en.wikipedia.org/wiki/Monkey_patch">monkey patching</a>, and adds the method directly to the Array class, adding this behaviour to every array instance.

<script src="https://gist.github.com/702437.js"> </script>
