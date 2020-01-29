function! s:get_repo_name(origin_url)
	return substitute(substitute(substitute(a:origin_url, '^\(git\|git+ssh\)@\(.\+\)', '\2', 'i'), '\.git$', '', ''), ':', '/', '')
endfunction

function! s:get_line_expression(start_line, end_line)
  let l:start_line = a:start_line
  let l:end_line = a:end_line

  if l:start_line == l:end_line
    return printf('#L%d', l:start_line)
  endif

  return printf('#L%d-L%d', l:start_line, l:end_line)
endfunction

function! githuburl#create_url(...)
  if !a:0
    let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
    return 'g@'
  elseif a:0 > 1
    let [l:start_line, l:end_line] = [a:1, a:2]
  else
    let [l:start_line, l:end_line] = [line("'["), line("']")]
  endif

  let filename = shellescape(bufname('%'))

  let l:origin_url = trim(system('git config --get remote.origin.url'))
  let l:hash = trim(system(printf('git rev-list -1 HEAD %s', filename)))
  let l:file_path = trim(system(printf('git ls-files --full-name %s', filename)))

  let l:repo_name = s:get_repo_name(l:origin_url)
  let l:line_expr = s:get_line_expression(l:start_line, l:end_line)

  let url = printf('https://%s/blob/%s/%s%s', l:repo_name,l:hash, l:file_path, l:line_expr)

  let @+ = url

  echom url
endfunction
