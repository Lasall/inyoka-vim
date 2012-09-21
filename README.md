inyoka-vim
==========
inyoka-vim contains an [inyoka](http://inyokaproject.org) VIM syntax
highlighting scheme (with syntax folding) and some snipMate snippets for
VIM 7+.  
All color definitions are optimized for a dark colorscheme (I use
xoria256) but please feel free to propose changes (e.g. a complete suite
for a light colorscheme). Also inner file syntax highlighting of other
common languages is supported (c, cpp, sh/bash, python, perl, xml,
debsources, debcontrol).  
Adding other languages is very easy. Just look into the code line ~125.

I got inspiration from the markdown syntax scheme by Tim Pope.

inyoka-vim is licensed under the GNU Public license version 3 or (at your
opinion) any later version of this license.  
You find the license text under: http://www.gnu.org/licenses/gpl-3.0.txt


What works what doesn't?
------------------------
So far it's pretty usable (at least for me).

Everything works except following things:
 * Currently not all inline formattings are working (well) inside of blocks
(problems with perl). Actually there is perl highlighting but keywords
are missed.
 * Some languages will change leading #!code CODETYPE
identifier (make, perl, debsources).
 * Nested code blocks don't work ({{{ foobar {{{ barfoo \\}\\}\\} }}}). Use
inline templates instead.

If you find additional bugs/problems/failures please report them!


Installation
------------
Copy the *inyoka.vim* syntax file to your `$VIMRUNTIME/syntax` directory.
Then reload vim and set filetype to `inyoka` and use syntax foldmethod:
`:set ft=inyoka fdm=syntax`

To use snippets, first install snipMate from github repository:
[msanders/snipmate](https://github.com/msanders/snipmate.vim)  
Version from [vim.org](http://www.vim.org/) is not up to date (problems with \` completions).
Then copy *inyoka.snippet* to your snippet directory (`$VIMRUNTIME/snippet`)
and enjoy.


Contributions
-------------
You can propose color/snippet changes or pull requests, fork it, throw it away,
comment it, report bugs, rant it, like it - whatever you want.
