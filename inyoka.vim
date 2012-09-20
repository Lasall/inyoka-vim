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


syn match inyokaLineStart "^[<@]\@!" nextgroup=@inyokaBlock

syn cluster inyokaBlock contains=inyokaH1,inyokaH2,inyokaH3,inyokaH4,inyokaH5,inyokaH6
" syn cluster inyokaBlock contains=inyokaHeader
syn cluster inyokaInline contains=inyokaLineBreak,inyokaItalic,inyokaBold,inyokaBoldItalic,inyokaUnderline,inyokaCode,inyokaTemplateInline,inyokaLinks

" headings
syn region inyokaH1 matchgroup=inyokaHeadingDelimiter start="^=" end="=\+\s*$" keepend contains=@inyokaInline contained
syn region inyokaH2 matchgroup=inyokaHeadingDelimiter start="^==" end="=\+\s*$" keepend contains=@inyokaInline contained
syn region inyokaH3 matchgroup=inyokaHeadingDelimiter start="^===" end="=\+\s*$" keepend contains=@inyokaInline contained
syn region inyokaH4 matchgroup=inyokaHeadingDelimiter start="^====" end="=\+\s*$" keepend contains=@inyokaInline contained
syn region inyokaH5 matchgroup=inyokaHeadingDelimiter start="^=====" end="=\+\s*$" keepend contains=@inyokaInline contained
syn region inyokaH6 matchgroup=inyokaHeadingDelimiter start="^======" end="=\+\s*$" keepend contains=@inyokaInline contained


" inline markups
syn region inyokaItalic start="\S\@<=''\|''\S\@=" skip="\\'" end="\S\@<=''\|''\S\@=" keepend contains=inyokaLineStart
syn region inyokaBold start="\S\@<='''\|'''\S\@=" skip="\\'" end="\S\@<='''\|'''\S\@=" keepend contains=inyokaLineStart
syn region inyokaBoldItalic start="\S\@<='''''\|'''''\S\@=" skip="\\'" end="\S\@<='''''\|'''''\S\@=" keepend contains=inyokaLineStart
syn region inyokaUnderline start="\S\@<=__\|__\S\@=" skip="\\=" end="\S\@<=__\|__\S\@=" keepend contains=inyokaLineStart
syn region inyokaCode start="\S\@<=`\|`\S\@=" skip="\\`" end="\S\@<=`\|`\S\@=" keepend contains=inyokaLineStart

syn region inyokaLinks matchgroup=inyokaLinksDelimiter start="\[" skip="\\\]" end="\]" keepend contains=inyokaLinksOuter,inyokaLinksInterWiki,inyokaLinksInner

syn region inyokaTemplateInline matchgroup=inyokaTemplateDelimiter start="\[\[" skip="\\]\\]" end="\]\]" keepend contains=inyokaLineStart,inyokaTemplateKeywords,inyokaTemplateArgs,inyokaTemplateFalse

" links
syn match inyokaLinksInterWiki "[^ :]\+\s*:\@=" nextgroup=inyokaLinksInner skipwhite contained
syn match inyokaLinksOuter "\S\+://\S\+" nextgroup=inyokaLinksTitle skipwhite contained
syn region inyokaLinksInner matchgroup=inyokaLinksDelimiter start=":" end=":" keepend nextgroup=inyokaLinksTitle skipwhite contained

syn match inyokaLinksTitle ".*" contains=@inyokaInline contained

" Supportet templates or macros.
let s:template_str = ["Vorlage", "Inhaltsverzeichnis"]

syn match inyokaTemplateFalse ".*" contained
let s:exec_template_keywords = 'syn match inyokaTemplateKeywords "\s*\(' . join(s:template_str, '\|') . '\)\s*" contained'
exec s:exec_template_keywords
syn region inyokaTemplateArgs matchgroup=inyokaTemplateArgsDelimiter start="(" skip="\\)" end=")\s*" keepend contains=inyokaTemplateArg,inyokaTemplateParams contained
syn region inyokaTemplateParams start="[^,]" end="" keepend contained
" TODO: Check stash templates.
syn region inyokaTemplateArg matchgroup=inyokaTemplateArgDelimiter start="(\@<=[^,)]\+" end="" keepend contained


" template Language
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
" hi      inyokaHeader           guifg=red ctermfg=red gui=bold cterm=bold
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

hi def link inyokaCode             Identifier
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
hi          inyokaLinksInner       guifg=darkcyan ctermfg=darkcyan gui=underline cterm=underline
hi          inyokaLinksOuter       guifg=blue ctermfg=blue gui=underline cterm=underline
hi          inyokaLinksInterWiki   guifg=yellow ctermfg=yellow
hi def link inyokaLinksDelimiter   Identifier

let b:current_syntax = "inyoka"

" vim:set sw=2:
