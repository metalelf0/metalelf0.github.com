---
layout: post
title: "Vim for Rails Developers, by Ben Orenstein"
tagline: "Screencast review"
category: vim
tags: [vim, rails, screencast, textmate, review, ben orentsein]
theme:
  name: journal
---
{% include JB/setup %}

[Codeulate Screencasts](http://www.codeulatescreencasts.com)

In the last months I've been working on a Rails project in an Agile team. I worked mostly on TextMate, and its speed is really amazing. It has a full set of features, with snippets, bundles, syntaxes and so on. It has many shortcuts, and apparently there's no need to switch away from TextMate.

But, it has its drawbacks: it's a Mac only application, so I can't use it on my Linux box. Also, it's a commercial application, and even if its cost is not too high, I don't like to pay for software. Finally, it's a GUI application, and it cannot be used over SSH to work on a production machine.

VIM always looked like the perfect answer to these needs - but yet, getting the productivity I reached after one full year of TextMate requires some time. Every time I tried using VIM for some serious work, I ended up discouraged, because even the most basic stuff like file navigation and launching tests took ages, compared to the snap of fingers of TextMate.

I always like to challenge me though, so when I saw this screencast by Ben Orenstein I immediately decided to give it a try. And yes, it was a good decision!

The screencast begins with some general hints about typing speed, keyboard layouts and Dvorak keyboards. Even if it may not look strictly related to the main subject of the screencast, I appreciated this part, and I think many people will find it useful.

Then the video moves on to the vim-rails plugin by Tim Pope and highlights its main functionalities. Here you'll see clearly how this screencast is mostly intended to tell "stuff that matters" instead of just giving a plain list of features that you'll never use in ages.

In this section, the screencast shows how to launch tests, navigate between files, and execute Rake commands directly from your VIM session. I think this plugin has really a lot of features, too many to be covered in this screencast; Ben managed to make a good choice, selecting the fundamentals you'll use everyday.

Another amazing plugin is Snipmate: it allows to insert snippets of code by just inserting a few characters and hitting TAB. Ben quickly overviews it and shows its use - another must-have for TextMate aficionados like me ;)

After this follows a section about ctags and their integration with Rails and VIM. This is also really useful, and combined with rails-vim it provides a quick way to navigate between project files.

Finally, there's an overview of ACK - a grep replacement, focused on ease of use and speed - and its simple VIM integration. I'm also using Ack.mate, so I already knew it, and it's one of those tools you feel the lack of when you don't find it installed.

Before ending the screencast, Ben also shows an overviews of single commands and configurations that he finds particularly useful. Again, they're being selected with usefulness in mind, so you'll end up with that "Wow, I need to try these now!" wonderful sensation.

What else can I say? The screencast is well done, has a nice music, a simple and clean layout and it's spoken in a clear English ;) This should be obvious but I've found a lot of screencasts with crazily fast voices, so it's not so obvious :)

To improve this screencast, I have nothing to say about its content: it's really great! I would only add some OSD with keys when key combinations are being explained, so that it could be even simpler to memorize them.

I would definitely recommend this to any Rails developer wanting to try VIM, or to any VIM user who is starting to code Rails and wants to boost his productivity. It has a good amount of tricks and hints that can be useful both for the VIM neophyte and the VIM master starting a Rails project.
