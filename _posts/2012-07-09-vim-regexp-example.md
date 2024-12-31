---
title: 'Vim regexp example: make a variable out of params'
date: "2012-07-09T00:00:00Z"
categories:
- posts
- technical
tags:
- vim
- rails
- ruby
- regexp
---


Today I wrote a regexp to change `params[:page]` into `page`. Here you are:

    :'<,'>s/params\[:\(\p\{-}\)\]/\1/g

Let's explain it briefly:

* the first part, `:'<,'>s/`, is the vim command to substitute a pattern (or a regexp) with another one. The `<,'>` part tells vim to operate on the visually selected text.

* the second part is the trickiest one. Let's see it part to part:

* `params\[:` is the first part of the string we want to match. the `\` is used to escape the `[` character.

* `\(\p\{-}\)` is the content between `params[:` and `]`. It consists of a sequence of printable characters (`\p`). The `\(` and `\)` characters around the sequence make it accessible to commands like substitute.  I used the `\{-}` quantifier instead of the `\+` because it is the non-greedy version; so, for example, if I had

      params[:page] = [ "a", "b", "c" ]

     Then `\p\{-}` would match only `:page`, while `\p\+` would match `:page] = [ "a", "b", "c" `.

* the `\]` part of the second block instructs the regexp parser to stop matching characters when it finds a `]` char.

* The third part, `\1`, tells vim what to replace with: the first match of the previous regexp. So, vim searches for the first `\(` and reads until `\)`, matches this and uses it for the substitution.

* Finally, `g` tells vim to make a global change and not to stop after the first occurrence.

