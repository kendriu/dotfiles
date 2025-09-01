return {
	-- GitHub integration for vim-fugitive
	"diepm/vim-rest-console",
	ft = "http", -- lazy load only for .http files (optional)
	-- build = function()
	-- 	-- Helper to run pip install for missing Python modules
	-- 	local function ensure_python_module(mod)
	-- 		local cmd = string.format('python3 -c "import %s"', mod)
	-- 		local ok = vim.fn.system(cmd) == ""
	-- 		if not ok then
	-- 			vim.notify(("Installing missing Python module: %s"):format(mod), vim.log.levels.INFO)
	-- 			local install = vim.fn.system(("python3 -m pip install --user %s"):format(mod))
	-- 			if vim.v.shell_error ~= 0 then
	-- 				vim.notify(("Error installing %s:\n%s"):format(mod, install), vim.log.levels.ERROR)
	-- 			end
	-- 		end
	-- 	end
	--
	-- 	ensure_python_module("pynvim")
	-- 	ensure_python_module("requests")
	-- 	vim.fn.system("nvim --headless +UpdateRemotePlugins +qall")
	-- end,
	config = function() end,
}
