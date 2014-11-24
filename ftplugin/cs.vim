if exists("b:did_dev_ftplugin")
  finish
endif
let b:did_dev_ftplugin = 1

if !exists("*s:DoBuild")
    function s:DoBuild()
        :w
        call base#SetCurDir()
        let prog = s:GetProg()
        if filereadable(prog)
            call delete(prog)
        endif
        :silent make %:t

        if filereadable(prog)
            :ccl
        else
            :cope
        endif
    endfunction
endif

if !exists("*s:GetProg")
    function s:GetProg()
        return expand("%:t:r").".exe"
    endfunction
endif

if !exists("*s:DoRun")
    function s:DoRun(...)
        let prog = s:GetProg()
        call s:DoBuild()
        if filereadable(prog)
            let index = 1
            let args = ""
            while index <= a:0
                let args = args." ".a:{index}
                let index = index + 1
            endwhile
            echo system(prog.args)
        endif
    endfunction
endif

command! -buffer -nargs=0 DoBuild              call s:DoBuild()
command! -buffer -nargs=0 DoRun                call s:DoRun()
command! -buffer -nargs=* R                    call s:DoRun(<f-args>)

setlocal nosmarttab 
setlocal noexpandtab
setlocal makeprg=csc

map <buffer> <F7> :DoBuild<cr>
map <buffer> <F5> :DoRun<cr>

" buffer operation maps
nmap <buffer> <leader>cn :cn<cr>
nmap <buffer> <leader>cp :cp<cr>
set efm=%f(%l\\,%v):\ %t%*[^:]:\ %m,
            \%trror%*[^:]:\ %m,
            \%tarning%*[^:]:\ %m
function QfMakeConv()
   let qflist = getqflist()
   for i in qflist
      let i.text = iconv(i.text, "cp936", "utf-8")
   endfor
   call setqflist(qflist)
endfunction

au QuickfixCmdPost make call QfMakeConv()
au BufReadPost quickfix nmap q :ccl<cr>
