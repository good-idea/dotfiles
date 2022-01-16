vim.cmd([[
" Background & Current Line
hi Normal ctermfg=231 ctermbg=235 cterm=NONE guifg=#e6e1dc guibg=#242424 gui=NONE
hi CursorLine cterm=NONE ctermbg=236 guibg=#2f2f2f

hi Comment guifg=#747474 
hi DiagnosticError guifg=#c63629 " A nicer error color
hi link FloatBorder DiagnosticInfo
hi NormalFloat guifg=Normal

" JSX/TSX 
hi tsxTagName guifg=#e63682
hi tsxCloseString guifg=#e63682
hi tsxTag guifg=#07929e
hi tsxCloseTag guifg=#07929e
hi tsxAttributeBraces guifg=#809cdb
hi tsxEqual guifg=#809cdb
hi tsxTypeBraces guifg=#999999
hi tsxTypes guifg=#18a8b4
]])


-- styling for floating windows
vim.cmd [[
  autocmd ColorScheme * highlight NormalFloat guibg=blue
  autocmd ColorScheme * highlight FloatBorder guifg=green guibg=red
]]

