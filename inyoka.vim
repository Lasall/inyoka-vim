" VIM syntax file
" Language:     Inyoka
" Maintainer:   Dominique Lasserre <lasserre.d@gmail.com>
" Last Change: 2012 September 20
"
" This is based on the markdown.vim syntax highlighting by:
"     Tim (master of VIM) Pope <vimNOSPAM@tpope.org>

if exists("b:current_syntax")
  finish
endif

syn case match

" Supportet templates or macros.
" NOTE: Name template parent directory first in list.
let s:template_str = ["Vorlage", "Inhaltsverzeichnis"]


syn match inyokaLineStart "^[<@]\@!" nextgroup=@inyokaBlocks

syn cluster inyokaBlocks contains=inyokaH1,inyokaH2,inyokaH3,inyokaH4,inyokaH5,inyokaH6,inyokaBlock
syn cluster inyokaInline contains=inyokaLineBreak,inyokaItalic,inyokaBold,inyokaBoldItalic,inyokaUnderline,inyokaMono,inyokaTemplateInline,inyokaLinks,inyokaFlag,inyokaList

" headings
syn region inyokaH1 matchgroup=inyokaHeadingDelimiter start="^=" end="=\+\s*$" keepend contains=@inyokaInline contained
syn region inyokaH2 matchgroup=inyokaHeadingDelimiter start="^==" end="=\+\s*$" keepend contains=@inyokaInline contained
syn region inyokaH3 matchgroup=inyokaHeadingDelimiter start="^===" end="=\+\s*$" keepend contains=@inyokaInline contained
syn region inyokaH4 matchgroup=inyokaHeadingDelimiter start="^====" end="=\+\s*$" keepend contains=@inyokaInline contained
syn region inyokaH5 matchgroup=inyokaHeadingDelimiter start="^=====" end="=\+\s*$" keepend contains=@inyokaInline contained
syn region inyokaH6 matchgroup=inyokaHeadingDelimiter start="^======" end="=\+\s*$" keepend contains=@inyokaInline contained


" template blocks
syn region inyokaBlock matchgroup=inyokaBlockDelimiter start="{{{" skip="\\}\\}\\}" end="}}}" keepend contains=inyokaTemplateBlock,inyokaCodeIdentifier contained

syn match inyokaTemplateTypeFalse ".*" contained
let s:exec_template_block = 'syn region inyokaTemplateBlock start="{\@<=\#\!' . s:template_str[0] . '\s\+\w\@=" skip="\\}\\}\\}" end="}}}" transparent contains=inyokaTemplateIdentifier,@inyokaInline contained'
let s:exec_block_identifier = 'syn match inyokaTemplateIdentifier "{\@<=\#\!' . s:template_str[0] . '\s\+\w\@=" nextgroup=inyokaTemplateType contained'
syn case ignore
exec s:exec_template_block
exec s:exec_block_identifier
syn case match
syn match inyokaTemplateType "\w\+" nextgroup=inyokaTemplateTypeFalse contained

syn match inyokaCodeIdentifier "{\@<=\#\!code\(\s\+\|$\)" nextgroup=inyokaCodeType contained
syn match inyokaCodeType "\w\+" nextgroup=inyokaTemplateTypeFalse contained
" TODO: Inline code highlighting.
" http://vim.wikia.com/wiki/Different_syntax_highlighting_within_regions_of_a_file

" lists
syn match inyokaList "^\s\+\([-*]\|1\.\)\%\(\s*\S\)\@="

" quotes
syn match inyokaQuote "^>\+\s*"


" inline markups
syn region inyokaItalic start="\S\@<=''\|''\S\@=" skip="\\'" end="\S\@<=''\|''\S\@=" keepend contains=inyokaLineStart
syn region inyokaBold start="\S\@<='''\|'''\S\@=" skip="\\'" end="\S\@<='''\|'''\S\@=" keepend contains=inyokaLineStart
syn region inyokaBoldItalic start="\S\@<='''''\|'''''\S\@=" skip="\\'" end="\S\@<='''''\|'''''\S\@=" keepend contains=inyokaLineStart
syn region inyokaUnderline start="\S\@<=__\|__\S\@=" skip="\\=" end="\S\@<=__\|__\S\@=" keepend contains=inyokaLineStart
syn region inyokaMono start="\S\@<=`\|`\S\@=" skip="\\`" end="\S\@<=`\|`\S\@=" keepend contains=inyokaLineStart

syn region inyokaLinks matchgroup=inyokaLinksDelimiter start="\[" skip="\\\]" end="\]" keepend contains=inyokaLinksOuter,inyokaLinksInterWiki,inyokaLinksInner

syn region inyokaTemplateInline matchgroup=inyokaTemplateDelimiter start="\[\[" skip="\\]\\]" end="\]\]" keepend contains=inyokaLineStart,inyokaTemplateKeywords,inyokaTemplateArgs,inyokaTemplateFalse

" links
syn match inyokaLinksInterWiki "[^ :]\+\s*:\@=" nextgroup=inyokaLinksInner skipwhite contained
syn match inyokaLinksOuter "\S\+://\S\+" nextgroup=inyokaLinksTitle skipwhite contained
syn region inyokaLinksInner matchgroup=inyokaLinksDelimiter start=":" end=":" keepend nextgroup=inyokaLinksTitle skipwhite contained
syn match inyokaLinksTitle ".*" contains=@inyokaInline contained

syn match inyokaTemplateFalse ".*" contained
let s:exec_template_keywords = 'syn match inyokaTemplateKeywords "\s*\(' . join(s:template_str, '\|') . '\)\s*" contained'
exec s:exec_template_keywords
syn region inyokaTemplateArgs matchgroup=inyokaTemplateArgsDelimiter start="(" skip="\\)" end=")\s*" keepend contains=inyokaTemplateArg,inyokaTemplateParams contained
syn region inyokaTemplateParams start="[^,]" end="" keepend contained
" TODO: Check templates.
syn region inyokaTemplateArg matchgroup=inyokaTemplateArgDelimiter start="(\@<=[^,)]\+" end="" keepend contained


" template Language
" TODO: Do the crazy inyoka template language highlightings.
" syn keyword inyokaTemplateKeyword if in endif for endfor contained


" flags
syn match       inyokaFlag            /{[^{}]\+}/

" line
syn match       inyokaRule            /^-\{4,\}/

" tags
syn match       inyokaTag             /^#\s\+tag:.*$/

" comments
syn match       inyokaComment         /^##.*$/


" Define the default highlighting.
" This is optimized for dark color scheme. I use xoria256.
hi          inyokaHeadingDelimiter guifg=red ctermfg=red gui=none cterm=none
hi          inyokaH1               guifg=red ctermfg=red gui=bold,underline cterm=bold,underline
hi          inyokaH2               guifg=red ctermfg=red gui=bold,underline cterm=bold,underline
hi          inyokaH3               guifg=red ctermfg=red gui=bold,underline cterm=bold,underline
hi          inyokaH4               guifg=red ctermfg=red gui=bold,underline cterm=bold,underline
hi          inyokaH5               guifg=red ctermfg=red gui=bold,underline cterm=bold,underline
hi          inyokaH6               guifg=red ctermfg=red gui=bold,underline cterm=bold,underline

hi          inyokaItalic           guifg=white ctermfg=white
hi          inyokaBold             gui=bold cterm=bold
hi          inyokaBoldItalic       guifg=white ctermfg=white gui=bold cterm=bold
hi          inyokaUnderline        gui=underline cterm=underline
hi def link inyokaMono             Identifier

hi          inyokaQuote            guifg=yellow ctermfg=yellow

hi          inyokaList             guifg=magenta ctermfg=magenta

hi          inyokaBlock            ctermfg=lightgrey
hi          inyokaBlockDelimiter   guifg=lightred ctermfg=lightred
hi def link inyokaTemplateIdentifier Define
hi          inyokaTemplateType      guifg=yellow ctermfg=yellow gui=bold cterm=bold
hi def link inyokaTemplateTypeFalse Error
hi def link inyokaCodeIdentifier   Define
hi          inyokaCodeType         guifg=yellow ctermfg=yellow gui=bold cterm=bold

hi def link inyokaTemplateInline   Define
hi def link inyokaTemplateFalse    Error
hi def link inyokaTemplateDelimiter Identifier

hi def link inyokaTemplateKeyword  Statement
hi def link inyokaTemplateKeywords Statement
hi def link inyokaTemplateArgs     Define
hi def link inyokaTemplateArgsDelimiter Define
hi def link inyokaTemplateArgDelimiter Number
hi def link inyokaTemplateParams   Constant

hi def link inyokaFlag             Define
hi def link inyokaRule             Special
hi def link inyokaTag              Tag
hi def link inyokaComment          Comment

hi def link inyokaUrl              Define
hi          inyokaLinksTitle       guifg=lightred ctermfg=red
hi          inyokaLinksInner       guifg=lightblue ctermfg=lightblue gui=underline cterm=underline
hi          inyokaLinksOuter       guifg=blue ctermfg=blue gui=underline cterm=underline
hi          inyokaLinksInterWiki   guifg=green ctermfg=green
hi def link inyokaLinksDelimiter   Identifier

let b:current_syntax = "inyoka"

" vim:set sw=2:
