---
title: Vim - sort ruby methods by name
date: "2016-07-29T00:00:00Z"
categories:
- posts
- technical
tags:
- vim
- ruby
---

Yesterday I had to refactor a very large ruby class. It had a lot of methods and, to make it cleaner, I decided to sort methods alphabetically.

Is there a way to do this in vim? Of course there is, and it's quite tricky - so let's see how we can do it.

The basic idea is taken from [this post on wincent.com](https://wincent.com/wiki/Sorting_functions_by_name_in_Vim), I just adapted it for ruby. All credits to this guy for his work :)

We'll use the same approach of the original post: first we'll collapse each ruby method on a single line, using a defined pattern to replace line terminators. We'll proceed sorting the one-lined methods, and finally we'll expand them back to multi-line.

These are the three commands, we'll explain them in detail later:

```
:'<,'>g/\vdef\ /,/\v^\s*end$/ s/$\n/@@@
:'<,'>sort
:'<,'>s/@@@/\r/g
```

Let's do it step by step.

### 1. Collapsing on a single line

First, we visually select the methods we want to sort, and issue this command:

```
:'<,'>g/\vdef\ /,/\v^\s*end$/ s/$\n/@@@
```

This will apply a global command on every instance of a defined pattern inside our visual selection. Look at the documentation inside vim for global commands (`:help :g`):

```
*:g* *:global* *E147* *E148*

:[range]g[lobal]/{pattern}/[cmd]
Execute the Ex command [cmd] (default ":p") on the
lines within [range] where {pattern} matches.
```

So, our _range_ is `'<,'>` (this means from `<` mark to `>` mark, in other words from the beginning of the visual selection to its end); our _pattern_ is `\vdef\ /,/\v^\s*end$/`. This means everything from `def\ ` (a def followed by a space) to `\^s*end$` (a line starting with any number of spaces, followed by `end` and the end of line).

`/,/` is how range beginning and end are separated; the `\v` is used to toggle the `very magic` mode, which allows a less verbose regexp syntax (see `:help \v` for more info).

Finally, our Ex command _cmd_ is `s/$\n/@@@`. It's a simple substitution: replace each line ending with our defined pattern, `@@@`.


### 2. Sorting collapsed lines

This is easy. Just visually select the collapsed lines and issue

```
:'<,'>sort
```

### 3. Expand lines back with line returns

Again, select the sorted lines (you can use `gv` to redo the last visual selection) and issue this command:

```
:'<,'>s/@@@/\r/g
```

This is a simple substitution: it replaces our defined pattern, `@@@`, with a line return (`\r`).

I hope you've learnt something from this article, I love that even after many years of vim usage I'm still surprised by its powerfulness every day. Have a good day!

