" Vim indent file
" Language:    MIPS
" Maintainer:  Shoaib Meenai <meenai1@illinois.edu>

if exists("b:did_indent")
	finish
endif
let b:did_indent = 1

setlocal indentexpr=GetMipsIndent()
setlocal indentkeys=!^F,o,O,<:>,0#,=,*<Return>
setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab

if exists("*GetMipsIndent")
  finish
endif

let s:label_rx = '^[^#]*:'
let s:equate_rx = '^[^#]*='
let s:starts_with_comment_rx = '^\s*#'
let s:starts_with_directive_rx = '^\s*\.'

function GetMipsIndent()
	let line_number = v:lnum
	let line_contents = getline(line_number)

	if line_contents =~ s:label_rx || line_contents =~ s:equate_rx
		return 0
	endif

	if line_contents =~ s:starts_with_comment_rx
		" if this returns -1, we'll just keep the current indent, which will
		" have gotten set to &shiftwidth when inserting the line
		return indent(nextnonblank(line_number + 1))
	endif

	if line_contents =~ s:starts_with_directive_rx
		" if you manually indent assembler directives, prevent them from being
		" reindented
		return -1
	endif

	return &shiftwidth
endfunction
