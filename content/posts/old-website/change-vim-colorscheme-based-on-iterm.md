---
title: "Vim - Change Colorscheme Based on Iterm profile"
date: 2016-12-19
category: vim
tags: [vim]
---

I like to change my (neo)vim colorscheme quite frequently, and when I do I want
it to match my iterm colors. Many colorscheme authors also provide an iterm
color palette, so you can import the `.itermcolors` file, create a new iterm
profile with that palette, start a new session and you have the same vim
colorscheme in your iterm. But then, when you launch vim, you still have to 
type `:colorscheme somecolor`.

If you have many colorschemes - like I do - you might become bored of doing all of 
this every frickin time. Wouldn't it be really cool if, when launching
vim from within an iterm session with profile "solarized", then the solarized
vim colorscheme could be used automatically?

This is possible and this is what I put together to achieve it. The trick is to
use the `$ITERM_PROFILE` environment variable - iterm sets it when you launch a
new session. You can then change colorscheme based on that variable if you name
iterm profiles and vim colorschemes the same way.

```vim
" colors = array with names of available colorschemes
let colors = ['PaperColor', 'crayon', 'oceanicnext', 'gruvbox', 'solarized', 'hemisu', 'apprentice', 'jellybeans', 'wombat', 'monochrome', 'alduin', 'sierra', 'dracula', 'one', 'tender', 'ir_black', 'base16-eighties']
if $ITERM_PROFILE != ""
  " if the current ITERM_PROFILE environment is in the list of supported colorschemes...
  if index(colors, $ITERM_PROFILE) != -1
    " set it as current colorscheme
    color $ITERM_PROFILE
    " check for a setup file for the colorscheme (e.g. Airline theme, term colors etc.)
    if filereadable($HOME . "/.config/nvim/setup/color-" . $ITERM_PROFILE. ".vim")
      source $HOME/.config/nvim/setup/color-$ITERM_PROFILE.vim
    endif
  " support for -dark / -light variants
  " if ITERM_PROFILE ends with -dark or -light, and the rest of the word is in the
  " list of supported colorschemes..."
  elseif index(colors, substitute($ITERM_PROFILE, '-dark\|-light', '', '')) != -1
    " baseColor:  'solarized-dark' => 'solarized'
    let baseColor = substitute($ITERM_PROFILE, '-dark\|-light', '', '')
    " variant:  'solarized-dark' => 'dark'
    let variant   = substitute($ITERM_PROFILE, baseColor . '-', '', '')
    exe "color ".baseColor
    exe "set bg=".variant
    " check for a setup file for the colorscheme (e.g. Airline theme, term colors etc.)
    if filereadable($HOME . "/.config/nvim/setup/color-" . $ITERM_PROFILE . ".vim")
      source $HOME/.config/nvim/setup/color-$ITERM_PROFILE.vim
    endif
  endif
else
  " otherwise, just use the default colorscheme - apprentice
  color apprentice
  source $HOME/.config/nvim/setup/color-apprentice.vim
endif
```

Just add the code above to your `init.vim` file and you're all set.
I reckon this might not be the best vimscript ever, so if you have any
suggestion - or you've found a better way to achieve the same results -
drop a line!
