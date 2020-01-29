" Function to create github urls for the current line of code
function! s:GithubUrl(...)
  if !a:0
    let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
    return 'g@'
  elseif a:0 > 1
    let [l:start_line, l:end_line] = [a:1, a:2]
  else
    let [l:start_line, l:end_line] = [line("'["), line("']")]
  endif

  let l:origin_url = trim(system('git config --get remote.origin.url'))
  let l:hash = trim(system('git rev-parse --verify HEAD'))
  let l:nested_directories = trim(system('export PROJECT_GIT_DIR=$(git rev-parse --show-toplevel);pwd|sed "s|$PROJECT_GIT_DIR||"|tr -d "[:space:]"'))

  let l:repo_name = substitute(substitute(substitute(l:origin_url, '^\(git\|git+ssh\)@\(.\+\)', '\2', 'i'), '\.git$', '', ''), ':', '/', '')
  let filename = bufname('%')

  let l:line_expr = '#L' . l:start_line

  if l:start_line != l:end_line
    let l:line_expr .= '-L' . l:end_line
  endif
  let url = 'https://' . l:repo_name . '/blob/' . l:hash . l:nested_directories . '/' . filename . l:line_expr

  let @+ = url

  echom url
endfunction

command! -range -bar GithubUrl call s:GithubUrl(<line1>, <line2>)

vnoremap <expr> <plug>GithubUrl <sid>GithubUrl()
nnoremap <expr> <plug>GithubUrl <sid>GithubUrl()
