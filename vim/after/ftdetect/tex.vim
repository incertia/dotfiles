" this function inserts a \begin{env}[opt]<CR>\end{env}
function! TexEnv(env, ...)
    " get [option]
    let opt = a:0 >= 1 ? "[" . a:1 . "]" : ""

    " determine if we should insert the [option]
    let l = getline('.')
    let ins = match(l, "^\\s*$") != -1 ? "S" : "O"

    " enumerate and itemize should have at least one item
    let extra = (a:env == "enumerate" || a:env == "itemize") ? "\\item " : ""

    :exe ":normal " . ins . "\\begin{" . a:env . "}" . opt
    :exe ":normal o" . "\\end{" . a:env . "}"
    :exe ":normal O" . extra
endfunction

" some : commands for <M-x> use and normal mode use
command! -nargs=* TexEnv call TexEnv(<f-args>)
command! TexSolution call TexEnv("proof", "Solution")

" set up autocommands for entering latex buffers
if has("autocmd")
    " for inserting general environments
    au FileType tex,latex inoremap <C-x><C-e> <C-o>:TexEnv<SPACE>

    " for inserting a solution in insert mode (requires vimacs)
    au FileType tex,latex inoremap <C-x><C-s> <C-o>:TexSolution<CR>
else
    echoerr "warning: latex imaps not loaded"
endif
