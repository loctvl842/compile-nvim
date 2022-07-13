#### INSTALLATION
```lua
use("loctvl842/compile-nvim")
```
#### CONFIGURATION
```lua
require("compile-nvim").setup({
	cmds = {
		typescript = "deno run %",
		javascript = "node %",
		markdown = "glow %",
		python = "python %",
		rust = "rustc % && ./$fileBase && rm $fileBase",
		rust = "cargo run",
		cpp = "g++ -O2 -Wall % -o $fileBase && ./$fileBase",
		go = "go run %",
		sh = "sh %",
	},

	-- UI settings
	ui = {
		-- Auto-save the current file
		-- before executing it
		autosave = true,

		-- Floating Window / FTerm settings
		-- Floating window border (see ':h nvim_open_win')
		border = "rounded",

		-- Num from `0 - 1` for measurements
		height = 0.8,
		width = 0.8,
		x = 0.5,
		y = 0.5,

		-- Highlight group for floating window/border (see ':h winhl')
		--border
		border_hl = "Normal",
		-- background
		normal_hl = "Normal",

		-- Floating Window Transparency (see ':h winblend')
		blend = 0,
	},
})
```

#### USAGE
Run file with command `:Compile`
