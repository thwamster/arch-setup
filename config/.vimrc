" thwamster's .vimrc

set tabstop=4 
set shiftwidth=4 
set autoindent 
set smartindent
set number
set encoding=utf-8
set nobackup
set nowritebackup
set t_Co=256

if has("autocmd")
	au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

let s:clip = '/mnt/c/Windows/System32/clip.exe'
if executable(s:clip)
	augroup WSLYank
		autocmd!
		autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
	augroup END
endif

autocmd vimenter * colorscheme fairyfloss

hi User1 ctermbg=black ctermfg=white guibg=black guifg=white
hi User2 ctermbg=black ctermfg=lightyellow guibg=black guifg=white
hi User3 ctermbg=black ctermfg=lightcyan guibg=black guifg=white
hi User4 ctermbg=black ctermfg=lightblue guibg=black guifg=white
hi User5 ctermbg=black ctermfg=lightgreen guibg=black guifg=white
hi User6 ctermbg=black ctermfg=lightred guibg=black guifg=white
hi User7 ctermbg=black ctermfg=lightmagenta guibg=black guifg=white
hi User8 ctermbg=black ctermfg=magenta guibg=black guifg=white

function! StatuslineGitBranch()
	let b:gitbranch=""
	if &modifiable
		try
			let l:dir=expand('%:p:h')
			let l:gitrevparse = system("git -C ".l:dir." rev-parse --abbrev-ref HEAD")
			if !v:shell_error
				let b:gitbranch="[".substitute(l:gitrevparse, '\n', '', 'g')."]"
			endif
		catch
		endtry
	endif
endfunction

augroup GetGitBranch
	autocmd!
	autocmd VimEnter,WinEnter,BufEnter * call StatuslineGitBranch()
augroup END

set laststatus=2
set statusline=%1*%F\ %2*%{b:gitbranch}\ %3*%y\ %4*%m%5*%h%6*%w%7*%r%8*%q
set statusline+=%=
set statusline+=%1*%l/%L\ %2*%c:%v\ (%P)\ %3*0x%04B\ %4*%{strftime(\"%H:%M\")}