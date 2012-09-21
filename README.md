inyoka-vim
==========
inyoka-vim contains an [inyoka](http://inyokaproject.org) VIM syntax
highlighting scheme (and in short some snipMate sippets) for VIM 7+.
All color definitions are optimized for a dark colorscheme (I use
xoria256) but please feel free to propose changes (e.g. a complete suite
for a light colorscheme). Also inner file syntax highlighting of other
common languages is supported (c, cpp, sh/bash, python, perl, xml,
debsources, debcontrol).
Adding other languages is very easy. Just look into the code line ~90.

I got inspiration from the markdown syntax scheme by Tim Pope.

inyoka-vim is licensed under the GNU Public license version 3 or (at your
opinion) any later version of this license.
You find the license text under: http://www.gnu.org/licenses/gpl-3.0.txt


What works what doesn't?
------------------------
So far it's pretty usable (at least for me). Template methods can
get improved to detect which arguments are valid and not all inline
formattings are working inside of blocks. But at the moment that's it.


Installation
------------
Copy the inyoka.vim syntax file to your `$VIMRUNTIME/syntax` directory.
Then reload vim and set filetype to `inyoka` and use syntax foldmethod:
`:set ft=inyoka fdm=syntax`


Contributions
-------------
You can propose color changes or pull requests, fork it, throw it away,
comment it, report bugs, rant it, like it - whatever you want.