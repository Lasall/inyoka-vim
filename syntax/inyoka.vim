" VIM syntax file
" Language:     Inyoka
" Maintainer:   Dominique Lasserre <lasserre.d@gmail.com>
" Last Change: 2012 September 21
"
" This is based on the markdown.vim syntax highlighting by:
"     Tim (master of VIM) Pope <vimNOSPAM@tpope.org>

if exists("b:current_syntax")
  finish
endif

" Function to highlight different regions with different syntax schemes.
" Modified version of vim.wikia:
" http://vim.wikia.com/wiki/Different_syntax_highlighting_within_regions_of_a_file
function! b:TextEnableCodeSnip2(filetype, bang) abort
  let ft=toupper(a:filetype)
  if exists('b:current_syntax')
    let s:current_syntax=b:current_syntax
    " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
    " do nothing if b:current_syntax is defined.
    unlet b:current_syntax
  endif
  try
    exec 'syn include @'.ft.' syntax/'.a:filetype.'.vim'
    try
      exec 'syn include @'.ft.' after/syntax/'.a:filetype.'.vim'
    catch
    endtry
    if exists('s:current_syntax')
      let b:current_syntax=s:current_syntax
    else
      unlet b:current_syntax
    endif
    exec 'syn region inyokaCodeBlock start="\({{{\)\@<=\#\!code\s\+'.a:bang.'\(\s\+\|$\)" skip="\\}\\}\\}" end="}}}" transparent contains=@'.ft.',inyokaCodeIdentifier contained'
  catch
  endtry
endfunction


" Enables special features for different templates.
function! b:TemplateHighlight(template, containings) abort
  exec 'syn region inyokaTemplateBlock start="\({{{\)\@<=\#\!'.b:template_macro.'\s\+'.a:template.'\(\s\+\|$\)" end="}}}" contains=inyokaTemplateIdentifier,'.a:containings.' contained'
endfunction


" Enables special features for different macros.
function! b:MacroInnerHighlight(macrotype, argn, containings)
  if a:argn == "NUMBER"
    exec 'syn match inyokaMacroArg "\(\s*'.a:macrotype.'\s*(\)\@<=\s*[0-9]\+\s*" nextgroup=inyokaTemplateFalse contained'
  elseif a:argn == "STRING"
    exec 'syn match inyokaMacroArg "\(\s*'.a:macrotype.'\s*(\)\@<=\s*[^, \t]\+\s*" nextgroup=inyokaTemplateFalse contains='.a:containings.' contained'
  elseif a:argn == 1
    exec 'syn match inyokaMacroParams "\(\s*'.a:macrotype.'\s*(\)\@<=\s*[^, \t]\+\s*" nextgroup=inyokaTemplateFalse contains='.a:containings.' contained'
  elseif a:argn == 2
    exec 'syn region inyokaMacroArg start="\(\s*'.a:macrotype.'\s*(\)\@<=\s*[^, \t]\+\(\s*,\s*\S.*)\)\@=" end=",\@=" nextgroup=inyokaMacroParams contains='.a:containings.' contained'
    exec 'syn region inyokaMacroParams start="\(\(\s*'.a:macrotype.'\s*(\s*[^, \t]\+\)\s*\(\(,\s*\)\?\)\)\@<=" end=",\@=" contains='.a:containings.' contained'
  elseif a:argn < 0
    exec 'syn region inyokaMacroArg start="\(\s*'.a:macrotype.'\s*(\)\@<=\s*[^, \t]\+\(\s*,\s*\S.*)\)\@=" end=",\@=" nextgroup=inyokaMacroParams contained'
    exec 'syn region inyokaMacroParams start="\(\(\s*'.a:macrotype.'\s*(\s*[^, \t]\+\)\>\s*\(\|,\s*\|,\s*[^,]\+.*\)\)\@<=" end=",\@=" contains='.a:containings.' contained'
  endif
endfunction

" Enables special features for different (inline) templates.
function! b:TemplateInnerHighlight(template, argn, containings)

  " NOTE: If you are bored, you can shorten those level 1 to 4 regexes.
  "       (But who cares, VIM would expand them... so no need to work on it)
  if a:argn == 0
    exec 'syn match inyokaTemplateArg "\(\s*'.a:template.'\s*\)" nextgroup=inyokaTemplateFalse contained'
  elseif a:argn == 1
    " Do some magic (verify that at least one valid parameter is given).
    exec 'syn region inyokaTemplateArg start="(\@<=\s*'.a:template.'\>\(\s*,\s*\S.*)\)\@=" end=",\@=" nextgroup=inyokaTemplateParams contains='.a:containings.' contained'
    " Do some magic (verify that exactly one valid parameter is given).
    exec 'syn region inyokaTemplateParams start="\(\((\s*'.a:template.'\)\>\s*\(\(,\s*\)\?\)\)\@<=" end=",\@=" contains='.a:containings.' contained'
  elseif a:argn == 2
    exec 'syn region inyokaTemplateArg start="(\@<=\s*'.a:template.'\>\(\s*,\s*\S.*)\)\@=" end=",\@=" nextgroup=inyokaTemplateParams contained'
    " Do more magic. You see the magic point?
    exec 'syn region inyokaTemplateParams start="\(\((\s*'.a:template.'\)\>\s*\(\|,\s*\|,\s*[^,]\+.\)\)\@<=" end=",\@=" contains='.a:containings.' contained'
  elseif a:argn == 3
    " Easy that was, now show me three, my young padavan.
    exec 'syn region inyokaTemplateArg start="(\@<=\s*'.a:template.'\>\(\s*,\s*\S.*)\)\@=" end=",\@=" nextgroup=inyokaTemplateParams contained'
    " No magic, that's intuitive.
    exec 'syn region inyokaTemplateParams start="\(\((\s*'.a:template.'\)\>\s*\(\|,\s*\|,\s*[^,]\+.\|,\s*[^,]\+\s*,\s*[^,]\+.\)\)\@<=" end=",\@=" contains='.a:containings.' contained'
  elseif a:argn == 4
    " Boring.
    exec 'syn region inyokaTemplateArg start="(\@<=\s*'.a:template.'\>\(\s*,\s*\S.*)\)\@=" end=",\@=" nextgroup=inyokaTemplateParams contained'
    exec 'syn region inyokaTemplateParams start="\(\((\s*'.a:template.'\)\>\s*\(\|,\s*\|,\s*[^,]\+.\|,\s*[^,]\+\s*,\s*[^,]\+.\|,\s*[^,]\+\s*,\s*[^,]\+\s*,\s*[^,]\+.\)\)\@<=" end=",\@=" contains='.a:containings.' contained'
  elseif a:argn < 0
    " To match it all (without ,).
    exec 'syn region inyokaTemplateArg start="(\@<=\s*'.a:template.'\>\(\s*,\s*\S.*)\)\@=" end=",\@=" nextgroup=inyokaTemplateParams contained'
    exec 'syn region inyokaTemplateParams start="\(\((\s*'.a:template.'\)\>\s*\(\|,\s*\|,\s*[^,]\+.*\)\)\@<=" end=",\@=" contains='.a:containings.' contained'
  endif
endfunction


syn case match

" Supportet macros.
let b:template_macro = "Vorlage"
let b:macros = ["Inhaltsverzeichnis", "Anker", "Anhang", "Bild"]

" Supported templates with {{{}}}.
" NOTE: Inyoka parser alwasy supports inline and block templates but we make a
"       difference.
" See http://wiki.ubuntuusers.de/Wiki/vorlagen .
let s:template_supported_block = ["Befehl", "Bildersammlung", "Builddeps", "Experten", "Hinweis", "Icon-Übersicht", "IM", "Namensliste", "Paketinstallation", "Tabelle", "Uebersicht", "Uebersicht2", "Warnung", "Wissen"]
" Inline templates: [[template_macro(TEMPLATE, parameters...)]]
let s:template_supported_inl = ['Archiviert', 'Ausbaufähig', 'Award', 'Baustelle', 'Befehl', 'Bildersammlung', 'Bildunterschrift', 'Code', 'Experten', 'Fortgeschritten', 'Fremd', 'Fremdpaket', 'Fremdquellle', 'Fremdquelle-auth', 'Getestet', 'Hinweis', 'Ikhayabild', 'InArbeit', 'PPA', 'Tasten', 'Überarbeitung', 'Verlassen', 'Warnung']


syn match inyokaLineStart "^[<@]\@!" nextgroup=@inyokaBlocks

syn cluster inyokaBlocks contains=inyokaH1fold,inyokaH2fold,inyokaH3,inyokaH4,inyokaH5,inyokaH6,inyokaBlock
syn cluster inyokaInline contains=inyokaItalic,inyokaBold,inyokaBoldItalic,inyokaUnderline,inyokaMono,inyokaStrikeout,inyokaSmaller,inyokaBigger,inyokaMarker,inyokaModTags,inyokaLinks,inyokaFlag,inyokaList,inyokaKeywords,inyokaTemplateInline,inyokaOldTable
syn cluster inyokaLevel1 contains=inyokaComment,inyokaQuote,inyokaTag,inyokaRule

" headings
" Folds level one and two.
" FIXME: This does not skip codeblocks with leading = .
syn region inyokaH1fold start="^=\([^=]\|$\)" end="\(^=\([^=]\|$\)\)\@=" keepend contains=inyokaH1,inyokaH2fold,@inyokaInline,@inyokaLevel1,@inyokaBlocks contained fold
syn region inyokaH1 matchgroup=inyokaHeadingDelimiter start="^=" end="=\+\s*$" keepend contained

syn region inyokaH2fold start="^==\([^=]\|$\)" end="\(^=\(=\)\?\([^=]\|$\)\)\@=" keepend contains=inyokaH2,@inyokaInline,@inyokaLevel1,@inyokaBlocks contained fold
syn region inyokaH2 matchgroup=inyokaHeadingDelimiter start="^==" end="=\+\s*$" keepend contained

syn region inyokaH3 matchgroup=inyokaHeadingDelimiter start="^===" end="=\+\s*$" keepend contains=@inyokaInline contained
syn region inyokaH4 matchgroup=inyokaHeadingDelimiter start="^====" end="=\+\s*$" keepend contains=@inyokaInline contained
syn region inyokaH5 matchgroup=inyokaHeadingDelimiter start="^=====" end="=\+\s*$" keepend contains=@inyokaInline contained
syn region inyokaH6 matchgroup=inyokaHeadingDelimiter start="^======" end="=\+\s*$" keepend contains=@inyokaInline contained


" template blocks
" TODO: Nested blocks are not supported (with closing \}\}\}).
syn region inyokaBlock matchgroup=inyokaBlockDelimiter start="{{{" end="}}}" keepend contains=inyokaTemplateBlock,inyokaCodeBlock fold

" templates
syn match inyokaTemplateTypeFalse ".*" contained
syn case ignore
exec 'syn region inyokaTemplateBlock start="\({{{\)\@<=\#\!'.b:template_macro.'\s\+\w\@=" end="}}}" contains=inyokaTemplateIdentifier contained'

" Enable inline support for these templates.
call b:TemplateHighlight("Tabelle", "@inyokaInline,inyokaMarker,@inyokaNewTable")
call b:TemplateHighlight("Befehl", "inyokaMarker")
call b:TemplateHighlight("Hinweis", "@inyokaInline,inyokaMarker")
call b:TemplateHighlight("Experten", "@inyokaInline,inyokaMarker")
call b:TemplateHighlight("Warnung", "@inyokaInline,inyokaMarker")
call b:TemplateHighlight("Wissen", "@inyokaInline,inyokaMarker")
call b:TemplateHighlight("Paketinstallation", "@inyokaInline,inyokaMarker,@inyokaPackageList")

exec 'syn match inyokaTemplateIdentifier "\({{{\)\@<=\#\!'.b:template_macro.'\s\+\w\@=" nextgroup=inyokaTemplateType contained'
syn match inyokaTemplateType "\w\+" nextgroup=inyokaTemplateTypeFalse contained

" Only match supported templates.
" TODO: Add option to disable this.
exec 'syn match inyokaTemplateType "\(\<\('.join(s:template_supported_block, '\|').'\)\>\)\@!" contains=inyokaTemplateTypeFalse contained'

" code
syn match inyokaCodeIdentifier "\({{{\)\@<=\#\!code\(\s\+\|$\)" nextgroup=inyokaCodeType contained
syn match inyokaCodeType "\w\+" nextgroup=inyokaTemplateTypeFalse contained

" We wan't display not recognised code properly.
syn region inyokaCodeBlock start="\({{{\)\@<=\#\!code\(\s\+\|$\)" end="}}}" transparent contains=inyokaCodeIdentifier contained

" include inline code highlightings
" This is very expensive, so only enable common types.
" TODO1: Is it possible to call only if needed? We would get matching from
"        inyokaTemplateIdentifier match.
" TODO2: Make config options. To enable/disalbe supported file types.
" File import errors are dropped silently.
"
" To add a new  language, add 'call s:TextEnableCodeSnip2('FT', 'REGEX')' where
" FT is the file extension which is used by VIM and REGEX is the regular
" expressions to detect the code identifier used by pygmentize (and inyoka).
call b:TextEnableCodeSnip2('sh', '\(\|ba\)sh')
call b:TextEnableCodeSnip2('debsources', '\(sourceslist\|sources\.list\)')
call b:TextEnableCodeSnip2('debcontrol', 'control')
call b:TextEnableCodeSnip2('python', 'python')
call b:TextEnableCodeSnip2('cpp', 'cpp')
call b:TextEnableCodeSnip2('perl', 'perl')
call b:TextEnableCodeSnip2('c', 'c')
call b:TextEnableCodeSnip2('xml', 'xml')
call b:TextEnableCodeSnip2('make', 'make')
call b:TextEnableCodeSnip2('diff', 'diff')
" call b:TextEnableCodeSnip2('html', 'html')
syn case match


" lists
syn match inyokaList "^\s\+\([-*]\|1\.\)\%\(\s*\S\)\@="

" quotes
syn region inyokaQuote start="^>" end="^\([^>]\|$\)\@=" contains=inyokaQuoteDelimiter,@inyokaBlocks,@inyokaInline fold
syn match inyokaQuoteDelimiter "^>\+" contained

" inline markups
syn region inyokaItalic start="\S\@<=''\|''\S\@=" skip="\\'" end="\S\@<=''\|''\S\@=" keepend contains=inyokaLineStart
syn region inyokaBold start="\S\@<='''\|'''\S\@=" skip="\\'" end="\S\@<='''\|'''\S\@=" keepend contains=inyokaLineStart
syn region inyokaBoldItalic start="\S\@<='''''\|'''''\S\@=" skip="\\'" end="\S\@<='''''\|'''''\S\@=" keepend contains=inyokaLineStart
syn region inyokaUnderline start="\S\@<=__\|__\S\@=" skip="\\=" end="\S\@<=__\|__\S\@=" keepend contains=inyokaLineStart
syn region inyokaMono start="\S\@<=`\|`\S\@=" skip="\\`" end="\S\@<=`\|`\S\@=" keepend contains=inyokaLineStart
syn region inyokaMono start="\S\@<=``\|``\S\@=" end="\S\@<=``\|``\S\@=" keepend contains=inyokaLineStart
syn region inyokaMono start="\S\@<=```\|```\S\@=" end="\S\@<=```\|```\S\@=" keepend contains=inyokaLineStart
syn region inyokaStrikeout start="\S\@<=--(\|--(\S\@=" end="\S\@<=)--\|)--\S\@=" keepend contains=inyokaLineStart
syn region inyokaSmaller start="\S\@<=\~-(\|\~-(\S\@=" end="\S\@<=)-\~\|)-\~\S\@=" keepend contains=inyokaLineStart
syn region inyokaBigger start="\S\@<=\~+(\|\~+(\S\@=" end="\S\@<=)+\~\|)+\~\S\@=" keepend contains=inyokaLineStart

syn region inyokaLinks matchgroup=inyokaLinksDelimiter start="\[" skip="\\\]" end="\]" keepend contains=inyokaLinksOuter,inyokaLinksInterWiki,inyokaLinksInner,inyokaPointer,inyokaLineStart

syn region inyokaTemplateInline matchgroup=inyokaTemplateDelimiter start="\[\[" skip="\\]\\]" end="\]\]" keepend contains=inyokaLineBreak,inyokaTemplateKeywords,inyokaMacroKeywords,inyokaTemplateArgs,inyokaTemplateFalse,inyokaLineStart fold

" links
syn match inyokaLinksInterWiki "[^ :]\+\s*:\@=" nextgroup=inyokaLinksInner skipwhite contained
syn match inyokaLinksOuter "\S\+://\S\+" nextgroup=inyokaLinksTitle skipwhite contained
syn region inyokaLinksInner matchgroup=inyokaLinksDelimiter start=":" end=":" keepend nextgroup=inyokaLinksTitle skipwhite contained
syn region inyokaLinksInner matchgroup=inyokaLinksDelimiter start="#" end=" " keepend nextgroup=inyokaLinksTitle skipwhite contained
syn match inyokaLinksTitle ".*" contains=@inyokaInline contained

" templates
syn match inyokaTemplateFalse ".*" contained
syn case ignore
exec 'syn match inyokaTemplateKeywords "\s*'.b:template_macro.'\s*" contained'
exec 'syn region inyokaTemplateArgs matchgroup=inyokaTemplateArgsDelimiter start="\(\s*'.b:template_macro.'\s*\)\@<=(" skip="\\)" end=")\s*" keepend contains=inyokaTemplateFalse,inyokaTemplateArg,inyokaTemplateParams contained'

" NOTE: Per template check is too much overhead.
"       Complete list with infinite arguments is used instead. Those
"       templates that don't need arguments are called below manually (and
"       some common ones).
" call b:TemplateInnerHighlight('\('.join(s:template_supported_inl, '\|').'\)', 0, "NONE")
call b:TemplateInnerHighlight('\('.join(s:template_supported_inl, '\|').'\)', -1, "NONE")

" Check inline template parameters.
" call b:TemplateInnerHighlight("Archiviert", 0, "NONE")
" call b:TemplateInnerHighlight("Archiviert", 1, "@inyokaInline")
" call b:TemplateInnerHighlight("Ausbaufähig", 0, "NONE")
" call b:TemplateInnerHighlight("Ausbaufähig", 1, "@inyokaInline")
" call b:TemplateInnerHighlight("Award", 3, "NONE")
" call b:TemplateInnerHighlight("Baustelle", -1, "NONE")
" call b:TemplateInnerHighlight("Befehl", -1, "inyokaMarker")
call b:TemplateInnerHighlight("Bildunterschrift", -1, "@inyokaPictureSmall")
call b:TemplateInnerHighlight("Fortgeschritten", 0, "NONE")
call b:TemplateInnerHighlight("Getestet", -1, "inyokaUbuntuVersions")
" call b:TemplateInnerHighlight("Verlassen", 0, "NONE")
" call b:TemplateInnerHighlight("Verlassen", 1, "NONE")


" macros
exec 'syn match inyokaMacroKeywords "\s*\('.join(b:macros, '\|').'\)\s*" contained'
exec 'syn region inyokaTemplateArgs matchgroup=inyokaTemplateArgsDelimiter start="\(\s*\('.join(b:macros, '\|').'\)\s*\)\@<=(" skip="\\)" end=")\s*" keepend contains=inyokaTemplateFalse,inyokaMacroArg,inyokaMacroParams contained'
call b:MacroInnerHighlight("Inhaltsverzeichnis", "NUMBER", "NONE")
call b:MacroInnerHighlight("Anker", 1, "NONE")
call b:MacroInnerHighlight("Anhang", "STRING", "NONE")
call b:MacroInnerHighlight("Anhang", 2, "NONE")
call b:MacroInnerHighlight("Bild", "STRING", "NONE")
call b:MacroInnerHighlight("Bild", -1, "@inyokaPictureExt")

syn case match

" pointers
syn match inyokaPointer "\s*\d\+\s*" contained nextgroup=inyokaPointerFalse
syn match inyokaPointerFalse ".*" contained

" line break
syn match inyokaLineBreak "\s*BR\s*" contained

" mod tags and marker
syn region inyokaMarker start="\[mark\]" end="\[/mark\]" keepend contains=inyokaLineStart
syn region inyokaModTags start="\[mod=[^]]*\]" end="\[/mod\]" keepend contains=inyokaLineStart
syn region inyokaModTags start="\[edit=[^]]*\]" end="\[/edit\]" keepend contains=inyokaLineStart


" template Language
" TODO: Do the crazy inyoka template language highlightings.
" syn keyword inyokaTemplateKeyword if in endif for endfor contained


" flags
syn match inyokaFlag "{[^{}]\+}"

" line
syn match inyokaRule "^-\{4,}"

" tags
syn region inyokaTag start="^#\s*\(tag\|X-\w\+\):" end="$" contains=inyokaTagKeywords
syn region inyokaTagKeywords start="\(tag:\|X-\w\+:\|,\)\@<=" end="\(,\|$\)\@=" oneline contained

" comments
syn match inyokaComment "^##.*$"


" keywords
syn match inyokaKeywords "\\\\$"

" tables keywords
syn cluster inyokaNewTable contains=inyokaTableOpts,inyokaNewTableKeywords

syn region inyokaTableOpts matchgroup=inyokaTableDelimiter start="<" end=">" keepend contains=inyokaTableKeywords,inyokaTableString,inyokaTableRowOptions,inyokaTableOperators,inyokaTableNumbers contained
syn match inyokaTableKeywords "\(\(<\|\s\)\@<=\(-\||\)\(\d\+\(\s\|>\)\)\@=\|\(\s\|<\|\"\|:\|v\|(\|)\|\^\)\@<=\(:\|v\|(\|)\|\^\)\(\s\|>\|\(:\|v\|(\|)\|\^\)\)\@=\)" contained
syn match inyokaTableKeywords "\(<\s*\(-\d\+\(%\)\?\s*\)\?\|;\s*\"\s*\|\"\s*;\s*\)\@<=\(rowclass\|rowstyle\|cellclass\|cellstyle\|tablestyle\)\(=\)\@=" contained
syn match inyokaTableString "\"[^"]*\"" contains=inyokaTableOperators,inyokaTableOptions,inyokaTableStrNumbers,inyokaTableColor contained
syn match inyokaTableOptions "\(;\s*\|\"\)\@<=\(width\|\(background-\|\)color\)\(:\)\@=" contained
syn match inyokaTableOptions "\(;\s*\|\"\)\@<=\(\(\|kde-\|xfce-\|edu-\|studio-\|lxde-\)\(titel\|kopf\|highlight\)\|gruen\|gelb\|grau\)\(\s*;\|\s*\"\)\@=" contained
syn match inyokaTableOperators "\(=\|;\)" contained
syn match inyokaTableStrNumbers "\(:\s*\)\@<=\d\+\(%\)\?\(\s*\"\|\s*;\)\@=" contained
syn match inyokaTableNumbers "\( \|-\||\)\@<=\d\+\(%\)\?\(\s\|>\|\s*\"\|\s*;\)\@=" contained
syn match inyokaTableColor "\(color:\s*\)\@<=#[0-9A-Fa-f]\{6}\(\s*\"\|\s*;\)\@=" contained

" new table syntax
syn match inyokaNewTableKeywords "^+++$" contained

" old table syntax
syn region inyokaOldTable matchgroup=inyokaTableDelimiter start="^\s*||" end="||\s*$" keepend contains=inyokaTableOpts,inyokaOldTableKeywords,@inyokaBlocks,@inyokaInline
syn match inyokaOldTableKeywords "||" contained


" special features for some templates
" make components italic and packages bold
syn cluster inyokaPackageList contains=inyokaPackageComp,inyokaPackages
syn match inyokaPackageComp "\(main\|restricted\|universe\|multiverse\|ppa\)" contained
syn match inyokaPackages "^[a-zA-Z_-]\+" contained


" underline Ubuntu versions
syn case ignore
syn match inyokaUbuntuVersions "\(quantal\|precise\|oneiric\|natty\|lucid\|hardy\|general\)" contained
syn case match


" match picture macro keywords
syn cluster inyokaPictureExt contains=inyokaPictureKeywords,inyokaPictureOp,inyokaPictureAlign,inyokaPictureNumber
syn cluster inyokaPictureSmall contains=inyokaPictureKeywordsSmall,inyokaPictureAlignSmall,inyokaPictureNumber

syn match inyokaPictureKeywords "\(,\s*\)\@<=\<\(alt\|align\|title\|longdesc\)\>\(=\)\@=" contained
syn match inyokaPictureKeywordsSmall "\(,\s*\)\@<=\<\(xfce\|kde\|edu\|lxde\|studio\)-style\>\(=\)\@=" contained
syn match inyokaPictureOp "\(,\s*\(alt\|align\|title\|longdesc\)\)\@<==\(\S\)\@=" contained
syn match inyokaPictureAlign "\(,\s*\(\|align=\)\)\@<=\(right\|left\|center\)\>\s*\(,\|)\)\@=" contained
syn match inyokaPictureAlignSmall "\(,\s*\)\@<=\(right\|left\)\>\s*\(,\|)\)\@=" contained
syn match inyokaPictureNumber "\(,\)\@<=\s*\(\d\+x\|\)\d\+\s*\(,\|)\)\@=" contained


" Define the default highlighting.
" This is optimized for dark color scheme. I use xoria256.
hi          inyokaHeadingDelimiter guifg=red ctermfg=red gui=none cterm=none
hi          inyokaH1               guifg=red ctermfg=red gui=bold,underline cterm=bold,underline
hi          inyokaH2               guifg=red ctermfg=red gui=bold,underline cterm=bold,underline
hi          inyokaH3               guifg=red ctermfg=red gui=bold,underline cterm=bold,underline
hi          inyokaH4               guifg=red ctermfg=red gui=bold,underline cterm=bold,underline
hi          inyokaH5               guifg=red ctermfg=red gui=bold,underline cterm=bold,underline
hi          inyokaH6               guifg=red ctermfg=red gui=bold,underline cterm=bold,underline

hi def link inyokaLineBreak        Special
hi          inyokaItalic           guifg=white ctermfg=white
hi          inyokaBold             gui=bold cterm=bold
hi          inyokaBoldItalic       guifg=white ctermfg=white gui=bold cterm=bold
hi          inyokaUnderline        gui=underline cterm=underline
hi def link inyokaMono             Identifier
hi          inyokaStrikeout        guifg=yellow ctermfg=yellow gui=undercurl cterm=undercurl
hi          inyokaSmaller          guifg=lightmagenta ctermfg=lightmagenta
hi          inyokaBigger           guifg=white ctermfg=white gui=bold cterm=bold

hi          inyokaQuoteDelimiter   guifg=yellow ctermfg=yellow

hi          inyokaList             guifg=magenta ctermfg=magenta

hi          inyokaBlock            guifg=lightgrey ctermfg=lightgrey
hi          inyokaBlockDelimiter   guifg=lightred ctermfg=lightred
hi def link inyokaTemplateIdentifier Define
hi          inyokaTemplateType     guifg=yellow ctermfg=yellow gui=bold cterm=bold
hi def link inyokaTemplateTypeFalse Error
hi def link inyokaCodeIdentifier   Define
hi          inyokaCodeType         guifg=yellow ctermfg=yellow gui=bold cterm=bold

hi def link inyokaTableDelimiter   Identifier
hi def link inyokaTableKeywords    Statement
hi def link inyokaTableString      String
hi def link inyokaTableNumbers     Number
hi def link inyokaTableStrNumbers  Number
hi          inyokaTableColor       guifg=lightred ctermfg=lightred
hi          inyokaTableOptions     guifg=yellow ctermfg=yellow gui=underline cterm=underline

hi def link inyokaOldTableKeywords Identifier
hi def link inyokaNewTableKeywords Special

hi def link inyokaTemplateInline   Define
hi def link inyokaTemplateFalse    Error
hi def link inyokaTemplateDelimiter Identifier

hi def link inyokaTemplateKeyword  Statement
hi def link inyokaTemplateKeywords Statement
hi def link inyokaTemplateArgs     Define
hi def link inyokaTemplateArgsDelimiter Define
hi def link inyokaTemplateArg      Number
hi def link inyokaTemplateParams   Constant

hi def link inyokaMacroKeywords    Statement
hi def link inyokaMacroArg         Number
hi def link inyokaMacroParams      Constant

hi def link inyokaFlag             Define
hi def link inyokaRule             Special
hi def link inyokaTag              Tag
hi          inyokaTagKeywords      guifg=red ctermfg=lightred gui=bold cterm=bold
hi def link inyokaComment          Comment
hi def link inyokaKeywords         Special

hi def link inyokaUrl              Define
hi          inyokaLinksTitle       guifg=red ctermfg=red
hi          inyokaLinksInner       guifg=lightblue ctermfg=lightblue gui=underline cterm=underline
hi          inyokaLinksOuter       guifg=blue ctermfg=blue gui=underline cterm=underline
hi          inyokaLinksInterWiki   guifg=green ctermfg=green
hi def link inyokaLinksDelimiter   Identifier
hi def link inyokaPointer          Number
hi def link inyokaPointerFalse     Error

hi def link inyokaMarker           Todo
hi def link inyokaModTags          Error

hi          inyokaPackageComp      guifg=white ctermfg=white
hi          inyokaPackages         gui=bold cterm=bold

hi          inyokaUbuntuVersions   gui=underline cterm=underline

hi def link inyokaPictureKeywords  Statement
hi def link inyokaPictureKeywordsSmall Statement
hi def link inyokaPictureAlign     Tag
hi def link inyokaPictureAlignSmall Tag
hi def link inyokaPictureNumber    Number

let b:current_syntax = "inyoka"

" vim:set sw=2 ts=2 sts=2 et
