---
title: Add bundle dir to your ctags
date: "2012-03-26T00:00:00Z"
categories:
- posts
- technical
tags:
- vim
- rails
- ctags
- ruby

---


Ctags are a great way to improve navigation between large codebases. Used together with vim they allow to quickly jump to any method definition with just a keystroke - `C-]`. Adding your bundle dir when generating the tags file will allow jumping to the internals of the ruby gems you are using. Let's see how to do this.

The setup needed is the following:

1. install [Exuberant Ctags](http://http://ctags.sourceforge.net). I suggest using `brew install ctags`, and remember to fix your `$PATH` so that running `ctags --version` shows `Exuberant Ctags`.

2. From your project root directory build the tags file with `ctags -R .`. This will create a `tags` file in your dir. You can also run this command inside vim with `:!ctags -R .`.

3. Now, from within vim, you can use the following shortcuts:

        C-]     => jump to definition
        C-T     => jump back from the definition
        C-W C-] => Open the definition in an horizontal split.

Additional tricks can be found [here](http://stackoverflow.com/questions/563616/vim-and-ctags-tips-and-tricks).

Now, to add the bundle dir, you have to ensure that you're working with a rvm gemset for each project (sorry Ruby Rogues). Otherwise you could end up with different versions of each gem in your rvm gemset dir, and choosing the one to jump to would require a call to bundler.

Then you can do this:

1. run `bundle show a_gem_in_your_project`, e.g. `bundle show rake`

2. copy the path including the rvm gem dir, like

        /Users/metalelf0/.rvm/gems/ruby-1.9.3-p0@my_project

3. now run the ctags command passing this dir as an additional argument:

        ctags -R . /Users/metalelf0/.rvm/gems/ruby-1.9.3-p0@my_project

Now from within vim you'll be able to jump to the source of the gems your project is using. Cool, right? :)

