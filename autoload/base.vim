function base#SetCurDir()
    execute "cd ".substitute(expand("%:p:h"), " ", "\\\\ ", "g")
endfunction

function base#GetRunTime()
	if has("win32")
		return expand('$VIMRUNTIME').'\..\vimfiles'
	else
		return expand('~').'/.vim'
	endif
endfunction

function base#DoInConsole(cmd)
    let cmd = a:cmd
    let console = "e:\\software\\console2\\Console.exe"
    if filereadable(console)
        let curDir = expand("%:p:h") 
python << EOF
import os
import vim
curDir = vim.eval("curDir")
console = vim.eval("console")
cmd = vim.eval("a:cmd")
(v_path, v_exe) = os.path.split(console)
cmds = (v_exe, "-reuse", "-t", "cmd", "-d", curDir, "-r", '"/k'+cmd+'"')
os.spawnv(os.P_DETACH, console, cmds)
EOF
    else
        exec(":silent !".cmd)
    endif
endfunction

function base#DoRun(cmd,...)
    :w
    let index = 1
    let args = ""
    while index <= a:0
        let args = args." ".a:{index}
        let index = index + 1
    endwhile
    echo system(a:cmd." ".expand('%').args)
endfunction

function base#DoRunDetach(cmd,...)
    :w
    let index = 1
    let args = ""
    while index <= a:0
        let args = args." ".a:{index}
        let index = index + 1
    endwhile
    let cmds = a:cmd." ".expand('%').args
    call DoInConsole(cmds)
endfunction

