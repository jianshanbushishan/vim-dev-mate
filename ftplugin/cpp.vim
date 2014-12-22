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
        :silent make build=%:t

        if filereadable(prog)
            :ccl
        else
            :cope
        endif
    endfunction
endif

if !exists("*s:GetProg")
    function s:GetProg()
        if has("win32")
            let prog = 'build\'.expand("%:t:r").".exe"
        else
            let prog = 'build/'.expand("%:t:r")
        endif
        return prog
    endfunction
endif

if !exists("*s:DoCRunInConsole(")
    function s:DoCRunInConsole(...)
        let prog = s:GetProg()
        call s:DoBuild()
        if filereadable(prog)
            call base#DoInConsole(prog.args)
        endif
    endfunction
endif

if !exists("*s:DoCRun")
    function s:DoCRun(...)
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

if !exists("*s:DoDebug")
    function s:DoDebug()
        let prog = s:GetProg()
        call s:DoBuild()
        if filereadable(prog)
            let vim_r = base#GetRunTime()
            let cmd = 'gdb -x '.vim_r.'/gdb.txt '.s:GetProg()
            call base#DoInConsole(cmd)
        endif
    endfunction
endif

if !exists("*s:DoAsm")
    function s:DoAsm(bO2)
        :w
        let ext = expand("%:e")
        if ext == 'c'
            let GCC = 'gcc'
        else
            let GCC = 'g++'
        endif

        if a:bO2 == 1
            let cmd = GCC.' -S -O2 '.expand('%')
        else
            let cmd = GCC.' -S '.expand('%')
        endif
        call system(cmd)
        let f= expand("%:r").'.s'
        exec("e ".f)
    endfunction
endif

command! -buffer -nargs=0 DoBuild              call s:DoBuild()
command! -buffer -nargs=0 DoCRun               call s:DoCRun()
command! -buffer -nargs=0 DoCRun2              call s:DoCRunInConsole()
command! -buffer -nargs=0 DoDebug              call s:DoDebug()
command! -buffer -nargs=* R                    call s:DoCRun(<f-args>)
command! -buffer -nargs=* RR                   call s:DoCRunInConsole(<f-args>)
command! -buffer -nargs=0 DoAsm0               call s:DoAsm(0)
command! -buffer -nargs=0 DoAsm1               call s:DoAsm(1)

setlocal nosmarttab
setlocal noexpandtab
setlocal makeprg=scons

map <buffer> <F6> :DoAsm0<cr>
map <buffer> <F4> :DoAsm1<cr>
map <buffer> <F7> :DoBuild<cr>
map <buffer> <F5> :DoCRun<cr>
map <buffer> <S-F5> :DoCRun2<cr>
map <buffer> <F10> :DoDebug<cr>

" buffer operation maps
nmap <buffer> <leader>cn :cn<cr>
nmap <buffer> <leader>cp :cp<cr>

set efm=%f(%l):\ %t%*[^:]:\ %m,
            \%trror%*[^:]:\ %m,
            \%tarning%*[^:]:\ %m

au BufReadPost quickfix nmap q :ccl<cr>

