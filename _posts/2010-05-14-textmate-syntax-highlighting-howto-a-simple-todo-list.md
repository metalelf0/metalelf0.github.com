---
layout: post
title: "TextMate Syntax Highlighting Howto: A simple todo list"
category: textmate
tagline: step by step
tags: [textmate, syntax, todo, howto]
theme:
  name: journal
---

Today I wanted to add a syntax highlight for my todo list favourite format to TextMate.

<div style="margin: 1em; ">
  <img src="http://3.bp.blogspot.com/_XPYUQVFU0pU/S-1AWa--6HI/AAAAAAAAEpg/2l_vtTV49Q4/s320/Schermata+2010-05-14+a+14.20.55.png" border="0" alt="" />
</div>

Here's how to do it. In TextMate, go to Bundles, then Bundles Editor, then Edit Languages...

Click on the plus button in the lower left corner and choose "New Language". Paste the following code in place of the example code provided.

<script src="https://gist.github.com/702430.js"> </script>

This defines three patterns for each condition. They should be self-explanatory, I used only simple regexps here. Save your language definition, and it should appear in the languages combo of your Textmate.

To complete syntax highlighting, you also have to add the colors to your current textmate theme. In the application menu, go to Textmate, then Preferences, then Fonts &amp; Colors. For each pattern name, click the plus button and create a new element. It must have the pattern name as scope selector. Choose colors as you like.

<div style="margin: 1em;">
  <img src="http://2.bp.blogspot.com/_XPYUQVFU0pU/S-1CFirQNjI/AAAAAAAAEpw/RjteBwVjrgo/s320/Schermata+2010-05-14+a+14.28.17.png" border="0" alt="" />
</div>

References:

<a href="http://manual.macromates.com/en/language_grammars#example_grammar" target="_new">Textmate help</a>
<br/>
<br/>
<a href="http://macdevcenter.com/pub/a/mac/2007/04/11/customizing-textmate.html" target="_new">Mac Dev Center</a>
