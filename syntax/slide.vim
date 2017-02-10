" Vim syntax file
" Language:	Go Present(Slide) Syntax
" Maintainer:	Koichi Shiraishi
" Filenames:	*.slide

if exists("b:current_syntax")
  finish
endif

if !exists('main_syntax')
  let main_syntax = 'goslide'
endif

runtime! syntax/html.vim
unlet! b:current_syntax


if !exists('g:goslide_fenced_languages')
  let g:goslide_fenced_languages = []
endif
for s:type in map(copy(g:goslide_fenced_languages),'matchstr(v:val,"[^=]*$")')
  if s:type =~ '\.'
    let b:{matchstr(s:type,'[^.]*')}_subtype = matchstr(s:type,'\.\zs.*')
  endif
  exe 'syn include @goslideHighlight'.substitute(s:type,'\.','','g').' syntax/'.matchstr(s:type,'[^.]*').'.vim'
  unlet! b:current_syntax
endfor
unlet! s:type


syn sync minlines=10
syn case ignore


" goslide Title:
" TODO(zchee): hardcoded line number
syn match  goslideTitle      '^\%1l.*$' contains=goslideLineStart
syn match  goslideSubTitle   '^\%2l.*$' contains=goslideLineStart
syn match  goslideDate       '^\%3l.*$' contains=goslideLineStart
syn match  goslideTags       '^\%4l.*$' contains=goslideLineStart
syn match  goslideName       '^\%6l.*$' contains=goslideLineStart
syn match  goslideJobs       '^\%7l.*$' contains=goslideLineStart
syn match  goslideMail       '^\%8l.*$' contains=goslideLineStart
syn match  goslideAuthorUrl  '^\%9l.*$' contains=goslideLineStart
syn match  goslideTwitter   '^\%10l.*$' contains=goslideLineStart


" Go Present Preproc:
syn region goslideCodeLink        matchgroup=goslideCodeDelimiter  start=/\v^\.code/ end="$"  oneline keepend skipwhite contained
syn region goslidePlayLink        matchgroup=goslidePlayDelimiter  start=/\v^\.play/ end="$"  oneline keepend skipwhite contained
syn region goslideImage           matchgroup=goslideImageDelimiter  start=/\v^\.image/ end="$" oneline keepend nextgroup=goslideImageLink skipwhite contained
syn region goslideImageLink       matchgroup=goslideImageDelimiter start=" " end=" " oneline keepend contained
syn region goslideImageSize       matchgroup=goslideImageDelimiter start=/\v^\.image/ end="$" oneline keepend contained nextgroup=goslideImageLink,goslideImageSize skipwhite contains=goslideLineStart,@goslideInline,goslideImageLink,goslideImageSize
syn region goslideBackgroundLink  matchgroup=goslideBackgroundDelimiter  start=/\v^\.background/ end="$"  oneline keepend skipwhite contained
syn region goslideIframeLink      matchgroup=goslideIframeDelimiter  start=/\v^\.iframe/ end="$"  oneline keepend skipwhite contained
syn region goslideVideoLink       matchgroup=goslideVideoDelimiter  start=/\v^\.video/ end="$"  oneline keepend skipwhite contained
syn match  goslideLink            /\v^\.link\s/
syn region goslideHtmlLink        matchgroup=goslideHtmlDelimiter  start=/\v^\.html/ end="$"  oneline keepend skipwhite contained
syn region goslideCaption         matchgroup=goslideCaptionDelimiter start=/\v^\.caption/ end="$" oneline keepend skipwhite contained


" Valid:
syn match goslideValid '[<>]\c[a-z/$!]\@!'
syn match goslideValid '&\%(#\=\w*;\)\@!'


syn match goslideLineStart "^[<@]\@!" nextgroup=@goslideBlock,htmlSpecialChar
syn cluster goslideBlock contains=goslideTitle,goslideSubTitle,goslideDate,goslideTags,goslideName,goslideJobs,goslideMail,goslideAuthorUrl,goslideTwitter,goslideH1,goslideH2,goslideH3,goslideBlockquote,goslideListMarker,goslideOrderedListMarker,goslideCodeBlock,goslideRule,goslideCodeLink,goslidePlayDelimiter,goslideImage,goslideImageDelimiter,goslideImageLink,goslideImageSize,goslideBackground,goslideIframeLink,goslideVideoLink,goslideLink,goslideHtml,goslideCaption
syn cluster goslideInline contains=goslideLineBreak,goslideLinkText,goslideItalic,goslideBold,goslideBoldItalic,goslideCode,goslideEscape,@htmlTop,goslideError


" Header:
syn match goslideHeadingRule "^[=-]\+$" contained
syn region goslideH1 matchgroup=goslideHeadingDelimiter start="\*\s#\@!"      end="#*\s*$" keepend oneline contains=goslideLineStart,@goslideInline,goslideAutomaticLink contained
syn region goslideH2 matchgroup=goslideHeadingDelimiter start="\*\*\s#\@!"     end="#*\s*$" keepend oneline contains=goslideLineStart,@goslideInline,goslideAutomaticLink contained
syn region goslideH3 matchgroup=goslideHeadingDelimiter start="\*\*\*\s#\@!"    end="#*\s*$" keepend oneline contains=goslideLineStart,@goslideInline,goslideAutomaticLink contained


" Blockquote:
syn match goslideBlockquote ">\%(\s\|$\)" contained nextgroup=@goslideBlock


" ListMarker:
syn match goslideListMarker "\%(\t\| \{0,4\}\)[-]\%(\s\+\S\)\@=" contained
syn match goslideOrderedListMarker "\%(\t\| \{0,4}\)\<\d\+\.\%(\s\+\S\)\@=" contained


" Rule:
syn match goslideRule "\* *\* *\*[ *]*$" contained
syn match goslideRule "- *- *-[ -]*$" contained


" LineBreak:
syn match goslideLineBreak " \{2,\}$"


" Url:
syn region goslideIdDeclaration matchgroup=goslideLinkDelimiter start="^ \{0,3\}!\=\[" end="\]:" oneline keepend nextgroup=goslideUrl skipwhite
syn match  goslideUrl "\S\+" nextgroup=goslideUrlTitle skipwhite contained
syn region goslideUrl matchgroup=goslideUrlDelimiter start="<" end=">" oneline keepend nextgroup=goslideUrlTitle skipwhite contained
syn region goslideUrlTitle matchgroup=goslideUrlTitleDelimiter start=+"+ end=+"+ keepend contained
syn region goslideUrlTitle matchgroup=goslideUrlTitleDelimiter start=+'+ end=+'+ keepend contained
syn region goslideUrlTitle matchgroup=goslideUrlTitleDelimiter start=+(+ end=+)+ keepend contained

" Link:
syn region goslideLinkText matchgroup=goslideLinkTextDelimiter start="!\=\[\%(\_[^]]*]\%( \=[[(]\)\)\@=" end="\]\%( \=[[(]\)\@=" keepend nextgroup=goslideLink,goslideId skipwhite contains=goslideLineStart,@goslideInline
syn region goslideLink matchgroup=goslideLinkDelimiter start="(" end=")" contains=goslideUrl keepend contained
syn region goslideId matchgroup=goslideIdDelimiter start="\[" end="\]" keepend contained

syn region goslideAutomaticLink matchgroup=goslideUrlDelimiter start="<\%(\w\+:\|[[:alnum:]_+-]\+@\)\@=" end=">" keepend oneline


" Bold: *foo*
syn region goslideBold start="\S\@<=\*\|\*\S\w\@=" end="\S\w\@<=\*\|\*\S\w\@=" keepend oneline
" Italic: _foo_
syn region goslideItalic start="\S\@<=_\|_\S\w\@=" end="\S\w\@<=_\|_\S\w\@=" keepend oneline
" BoldItalic: '*_foo_*' or '_*foo*_'
" syn region goslideBoldItalic start="\S\@<=\*_\|\*_\S\w\@=" end="\S\w\@<=\*_\|\*_\S\w\@=" keepend
" syn region goslideBoldItalic start="\S\@<=_\*\|_\*\S\w\@=" end="\S\w\@<=_\*\|_\*\S\w\@=" keepend


" Inline Code:
syn region goslideCodeBlock matchgroup=goslideCodeDelimiter start="    \|\t" end="$" keepend contains=@goslideHighlightsh
syn region goslideCode matchgroup=goslideCodeDelimiter start="`" end="`" keepend contains=goslideLineStart
syn region goslideCode matchgroup=goslideCodeDelimiter start="`` \=" end=" \=``" keepend contains=goslideLineStart
syn region goslideCode matchgroup=goslideCodeDelimiter start="^\s*```.*$" end="^\s*```\ze\s*$" keepend


" Code Highlight:
if main_syntax ==# 'goslide'
  for s:type in g:goslide_fenced_languages
    exe 'syn region goslideHighlight'.substitute(matchstr(s:type,'[^=]*$'),'\..*','','').' matchgroup=goslideCodeDelimiter start="^\s*```'.matchstr(s:type,'[^=]*').'\>.*$" end="^\s*```\ze\s*$" keepend contains=@goslideHighlight'.substitute(matchstr(s:type,'[^=]*$'),'\.','','g')
  endfor
  unlet! s:type
endif

" Escape:
syn match goslideEscape "\\[][\\`*_{}()#+.!-]"
" Error:
syn match goslideError "\w\@<=\w\@="


" Highlight:
hi def link goslideTitle                 htmlH1
hi def link goslideSubTitle              htmlH2
hi def link goslideDate                  Number
hi def link goslideTags                  PreProc
hi def link goslideName                  Delimiter
hi def link goslideJobs                  String
hi def link goslideMail                  htmlLink
hi def link goslideAuthorUrl             htmlLink
hi def link goslideTwitter               htmlLink


hi def link goslideCodeDelimiter         PreProc
hi def link goslideCodeLink              htmlLink
hi def link goslidePlayDelimiter         PreProc
hi def link goslidePlayLink              htmlLink
hi def link goslideImageDelimiter        PreProc
hi def link goslideImageLink             htmlLink
hi def link goslideImageSize             Number
hi def link goslideBackgroundDelimiter   PreProc
hi def link goslideBackgroundLink        htmlLink
hi def link goslideIframeDelimiter       PreProc
hi def link goslideIframeLink            htmlLink
hi def link goslideLink                  PreProc
hi def link goslideHtmlDelimiter         PreProc
hi def link goslideHtmlLink              htmlLink
hi def link goslideVideoDelimiter        PreProc
hi def link goslideVideoLink             htmlLink
hi def link goslideCaptionDelimiter      PreProc
hi def link goslideCaption               String


hi def link goslideH1                    htmlH1
hi def link goslideH2                    htmlH2
hi def link goslideH3                    htmlH3
hi def link goslideHeadingRule           goslideRule
hi def link goslideHeadingDelimiter      Delimiter
hi def link goslideOrderedListMarker     goslideListMarker
hi def link goslideListMarker            htmlTagName
hi def link goslideBlockquote            Comment
hi def link goslideRule                  PreProc

hi def link goslideLinkText              htmlLink
hi def link goslideIdDeclaration         Typedef
hi def link goslideId                    Type
hi def link goslideAutomaticLink         goslideUrl
hi def link goslideUrl                   Float
hi def link goslideUrlTitle              String
hi def link goslideIdDelimiter           goslideLinkDelimiter
hi def link goslideUrlDelimiter          htmlTag
hi def link goslideUrlTitleDelimiter     Delimiter

hi def link goslideItalic                htmlItalic
hi def link goslideBold                  htmlBold
hi def link goslideBoldItalic            htmlBoldItalic
hi def link goslideCodeDelimiter         Delimiter

hi def link goslideEscape                Special
hi def link goslideError                 Error

let b:current_syntax = "goslide"
if main_syntax ==# 'goslide'
  unlet main_syntax
endif

" vim:set sw=2:
