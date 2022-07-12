local M = {}

local config = {
	cmds = {},
	ui = {
		wincmd = false,
		autosave = false,
		border = "none",
		height = 0.8,
		width = 0.8,
		x = 0.5,
		y = 0.5,
		border_hl = "FloatBorder",
		normal_hl = "Normal",
		blend = 0,
	},
}

local function floatingWin(cmd)
	M.buf = vim.api.nvim_create_buf(false, true)
	local win_height = math.ceil(vim.api.nvim_get_option("lines") * config.ui.height - 4)
	local win_width = math.ceil(vim.api.nvim_get_option("columns") * config.ui.width)
	local row = math.ceil((vim.api.nvim_get_option("lines") - win_height) * config.ui.y - 1)
	local col = math.ceil((vim.api.nvim_get_option("columns") - win_width) * config.ui.x)
	local opts = {
		style = "minimal",
		relative = "editor",
		border = config.ui.border,
		width = win_width,
		height = win_height,
		row = row,
		col = col,
	}
	M.win = vim.api.nvim_open_win(M.buf, true, opts)
	vim.api.nvim_buf_set_option(M.buf, "filetype", "Compile")
	vim.api.nvim_buf_set_keymap(
		M.buf,
		"t",
		"<ESC>",
		"<cmd>:lua vim.api.nvim_win_close(" .. M.win .. ", true)<CR>",
		{ silent = true }
	)
	vim.fn.termopen(cmd)
	-- always start INSERT mode after compile file
	vim.cmd("startinsert")
	vim.api.nvim_win_set_option(
		M.win,
		"winhl",
		"Normal:" .. config.ui.normal_hl .. ",FloatBorder:" .. config.ui.border_hl
	)
	vim.api.nvim_win_set_option(M.win, "winblend", config.ui.blend)
end

function M.setup(user_options)
	config = vim.tbl_deep_extend("force", config, user_options)
end

function M.compile()
	local cmd = config.cmds[vim.bo.filetype]
	if cmd ~= nil then
		cmd = cmd:gsub("%%", vim.fn.expand("%"))
		cmd = cmd:gsub("$fileBase", vim.fn.expand("%:r"))
		cmd = cmd:gsub("$filePath", vim.fn.expand("%:p"))
		cmd = cmd:gsub("$file", vim.fn.expand("%"))
		cmd = cmd:gsub("$dir", vim.fn.expand("%:p:h"))
		cmd = cmd:gsub(
			"$moduleName",
			vim.fn.substitute(
				vim.fn.substitute(vim.fn.fnamemodify(vim.fn.expand("%:r"), ":~:."), "/", ".", "g"),
				"\\",
				".",
				"g"
			)
		)
		cmd = cmd:gsub("$altFile", vim.fn.expand("#"))
		if config.ui.autosave then
			vim.cmd("write")
		end
		floatingWin(cmd)
	else
		vim.cmd("echohl ErrorMsg | echo 'Error: Invalid command' | echohl None")
	end
end

return M
