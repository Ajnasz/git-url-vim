function s:GithubUrl(...)
  return call('githuburl#CreateUrl', a:000)
endfunction

command! -range -bar GithubUrl call s:GithubUrl(<line1>, <line2>)

vnoremap <expr> <plug>GithubUrl <sid>GithubUrl()
nnoremap <expr> <plug>GithubUrl <sid>GithubUrl()
