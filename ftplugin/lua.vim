if exists("b:did_dev_ftplugin")
  finish
endif
let b:did_dev_ftplugin = 1

setlocal nosmarttab 
setlocal noexpandtab
call base#SetCurDir()
map <buffer> <F5> :call base#DoRun("lua")<cr>
command! -buffer -nargs=* R call base#DoRun("lua", <f-args>)
