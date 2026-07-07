function! s:find_latexmkrc(startdir) abort
  let dir = a:startdir
  while 1
    let rc = dir . '/.latexmkrc'
    if filereadable(rc)
      return rc
    endif
    let parent = fnamemodify(dir, ':h')
    if parent ==# dir
      return ''
    endif
    let dir = parent
  endwhile
endfunction

function! s:main_from_latexmkrc(rcpath) abort
  for l in readfile(a:rcpath)
    " Parse: @default_files = ('../notes-ahnaf.tex');
    let m = matchlist(l, "@default_files\\s*=\\s*(\\s*'\\([^']\\+\\)'")
    if !empty(m)
      let rel = m[1]
      let rcdir = fnamemodify(a:rcpath, ':h')
      return fnamemodify(rcdir . '/' . rel, ':p')
    endif
  endfor
  return ''
endfunction

function! Synctex() abort
  let src = expand('%:p')

  " Find and parse main tex from .latexmkrc
  let rc = s:find_latexmkrc(fnamemodify(src, ':h'))
  let main = (rc ==# '') ? '' : s:main_from_latexmkrc(rc)

  " Fallback if not found: assume current file is main
  if main ==# ''
    let main = src
  endif

  " main.pdf next to main.tex (robust extension change)
  let pdf = fnamemodify(main, ':r') . '.pdf'

  let vimura_param = printf(' --synctex-forward %d:%d:%s %s',
        \ line('.'), col('.'), src, pdf)

  if has('nvim')
    call jobstart('vimura neovim' . vimura_param)
  else
    execute 'silent !vimura vim' . vimura_param . '&'
  endif
  redraw!
endfunction
