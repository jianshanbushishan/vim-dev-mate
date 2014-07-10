if exists("b:did_dev_ftplugin")
  finish
endif
let b:did_dev_ftplugin = 1

setlocal nosmarttab 
setlocal noexpandtab
call base#SetCurDir()
map <buffer> <F5> :call base#DoRun("node")<cr>
command! -buffer -nargs=* R call base#DoRun("node", <f-args>)
