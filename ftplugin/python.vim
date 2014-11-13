if exists("b:did_dev_ftplugin")
  finish
endif
let b:did_dev_ftplugin = 1

map <buffer> <F5> :call base#DoRun("python")<cr>
map <buffer> <S-F5> :call base#DoRunDetach("python")<cr>
command! -buffer -nargs=* R call base#DoRun("python", <f-args>)
command! -buffer -nargs=* RR call base#DoRunDetach("python", <f-args>)
