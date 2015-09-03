" meta-x eXecute
inoremap <M-x> <C-o>:

" some control motions and operator/command equivalents
inoremap <C-a> <C-o>I
onoremap <C-a> 0
cnoremap <C-a> <Home>
inoremap <C-e> <C-o>A
onoremap <C-e> $
cnoremap <C-e> <End>
inoremap <C-b> <C-o><Left>
onoremap <C-b> h
cnoremap <C-b> <Left>
inoremap <C-f> <C-o><Right>
onoremap <C-f> l
cnoremap <C-f> <Right>

" nice to be able to easily delete current char
inoremap <C-d> <C-o>x
