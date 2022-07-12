vim.cmd([[command! -nargs=? -complete=customlist,CompileCompletion Compile :lua require('compile-nvim').compile()]])
