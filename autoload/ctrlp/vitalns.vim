scriptencoding utf-8

let s:ns = fnamemodify(expand('<sfile>'), ':t:r')
if exists(printf('g:loaded_ctrlp_%s', s:ns)) && g:loaded_ctrlp_{s:ns}
  finish
endif
let g:loaded_ctrlp_{s:ns} = 1

if !exists('s:Id') "{{{
  cal add(g:ctrlp_ext_vars, {
  \ 'init'  : printf('ctrlp#%s#init()', s:ns),
  \ 'accept': printf('ctrlp#%s#accept', s:ns),
  \ 'lname' : 'vital modules',
  \ 'sname' : s:ns,
  \ 'nolim' : 1,
  \ })
  let s:Id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
e0ndif "}}}

function! s:indexing() abort "{{{
  let htags = split(globpath(&rtp, 'doc/tags'), '\n')
  let vimhtag = glob('$VIMRUNTIME/doc/tags')
  let result = []
  let vzone = 0
  for htag in htags
    if htag !=# vimhtag && filereadable(htag)
      let lines = readfile(htag)
      for line in readfile(htag)
        if line[0] != 'V'
          if vzone | return result | endif
          continue
        endif
        if line[:5] ==# 'Vital.'
          let vzone = 1
          let line = split(line, '\v\s')[0]
          if line[-2:] ==# '()' && stridx(line, '-') == -1
            let line = line[:-3]
            silent! call ctrlp#progress(len(result) . ': [indexing/vital] ' . line)
            call add(result, line)
          endif
        endif
      endfor
      return result
    endif
  endfor
  return result
endfunction "}}}
function! s:find(str) abort "{{{
  let t = ['__latest__'] + split(a:str, '\v\.')[1:]
  let p = 'autoload/vital/' . join(t[:-2], '/') . '.vim'
  let name = t[-1]
  let path = get(split(globpath(&rtp, p), '\v\r\n|\n|\r'), 0, '')
  if path != '' && name != '' && filereadable(path)
    let regexp = '\v\C\s*fu%[nction](\!\s*|\s+)s:\V' . name . '\v\s*\([^)]*\)'
    let lines = readfile(path)
    for idx in range(len(lines))
      let col = match(lines[idx], regexp) + 1
      if col
        return {'path': path, 'line': idx + 1, 'col': col}
      endif
    endfor
  endif
  return {}
endfunction "}}}

function! ctrlp#{s:ns}#id() "{{{
  return s:Id
endfunction "}}}
function! ctrlp#{s:ns}#init() "{{{
  if !exists('s:vitaltags')
    let s:vitaltags = s:indexing()
    if type(s:vitaltags) isnot type([])
      let s:vitaltags = []
    endif
  endif
  return s:vitaltags
endfunction "}}}
function! ctrlp#{s:ns}#accept(mode, str) "{{{
  call ctrlp#exit()
  let d = s:find(a:str)
  if type(d) is type({}) && !empty(d)
    call ctrlp#acceptfile({'action': a:mode, 'line': d.path, 'tail': d.line})
    if has_key(d, 'col') && d.col != 0
      execute 'normal!' (d.col . '|')
    endif
  endif
endfunction "}}}

" vim:set et sts=2 ts=2 sw=2 fdm=marker:
