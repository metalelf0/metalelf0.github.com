+++
categories = ["tools"]
date = "2012-02-06T00:00:00Z"
tagline = "cause style matters"
tags = ["vim", "colorschemes", "ruby"]

[theme]
name = "journal"

title = "The right colors for your VIM"
+++


I have a lot of Vim colorschemes, and I like to change them very often, reflecting my mood. I needed a way to showcase them all and quickly pick one.

The original [Vim Color Scheme Test](https://code.google.com/p/vimcolorschemetest/) script by maverick.woo is written in Perl and the build works on Windows systems. I wanted to add some new features, and to test it with my own colorschemes, but as I'm not very confident with Perl, I preferred to start over with a new Ruby version instead of forking his project. Here's my version (and here's the [github page](https://github.com/metalelf0/VimColorSchemeTest-Ruby)):

![first img](https://github.com/metalelf0/VimColorSchemeTest-Ruby/raw/master/screenshots/screenshot_01.png)
![second img](https://github.com/metalelf0/VimColorSchemeTest-Ruby/raw/master/screenshots/screenshot_02.png)

The script loads all your colorschemes from your default vim directory (~/.vim/colors), and writes into the output dir an HTML file for each colorscheme, with a render of a Ruby file using this colorscheme. It also writes a different copy for each language present in the samples/ directory. It also builds an index page for each language, with a showcase of how the colorschemes render the sample code, a download link for each colorscheme and a nice lightbox to preview it.

To run it, you'll need:

* ruby
* macvim
* tilt rubygem (to render the index template)


What still needs to be done:

* Separate light and dark colorschemes
* Make this work with versions of vim different from MacVim
* Add the current language name to index pages
* Add more languages (currently only Ruby and Python are supported)


ATM, the script uses a vim server named VIMCOLORS and sends it remote commands. This was made to make it faster, because opening a single macvim instance for each script required too much time. However, the `--remote-send` command of vim doesn't wait for previous remote-sends to be completed, so I had to add a `sleep 1` command in the script to prevent it from messing up the execution flow. Any hint to solve this is greatly appreciated.

