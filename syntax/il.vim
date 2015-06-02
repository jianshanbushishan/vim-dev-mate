" Vim syntax file
" Language:     IL
" Maintainer:   shishuaiwei <shishuaiwei@gmail.com>
" Updaters:
" URL:
" Changes:
" Last Change:  2015-06-02

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'il'
endif

" Drop fold if it set but vim doesn't support it.
if version < 600 && exists("il_fold")
  unlet il_fold
endif

syn case ignore


syn match   ilLineComment       "\/\/.*" 
syn match   ilNumber            "-\=\<[0-9a-fA-F]\+L\=\>\|0[xX][0-9a-fA-F]\+\>" 
syn region  ilString            start=+"+  skip=+\\\\\|\\"\|\\$+  end=+"\|$+  contains=qmlSpecial,@htmlPreproc 
syn match   ilMacro             "^\s*\.\a\+"
syn keyword ilType              int string short void int32 long double float bool
syn match   ilLabel             "IL_[0-9a-fA-F]\+"
syn keyword ilException         try catch finally throw
syn keyword ilReserved          const enum export extern extends final goto implements interface private protected public short static super event delegate class

if get(g:, 'il_fold', 0)
  syn match   ilFunction      "\<method\>"
  syn region  ilFunctionFold  start="\<\.method\>.*[^};]$" end="^\z1}.*$" transparent fold keepend

  syn sync match ilSync  grouphere ilFunctionFold "\<\.method\>"
  syn sync match ilSync  grouphere NONE "^}"

  setlocal foldmethod=syntax
  setlocal foldtext=getline(v:foldstart)
else
  syn keyword ilFunction function
  syn match   ilBraces   "[{}\[\]]"
  syn match   ilParens   "[()]"
endif

syn sync fromstart
syn sync maxlines=100

if main_syntax == "il"
  syn sync ccomment ilLineComment
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_il_syn_inits")
  if version < 508
    let did_il_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink ilLineComment       Comment
  HiLink ilNumber            Number
  HiLink ilType              Type
  HiLink ilFunction          Function
  HiLink ilBraces            Function
  HiLink ilString            String
  HiLink ilMacro             Macro

  HiLink ilLabel             Comment
  HiLink ilException         Exception
  HiLink ilReserved          Keyword

  delcommand HiLink
endif

let b:current_syntax = "il"
if main_syntax == 'il'
  unlet main_syntax
endif
