-- Git integration for Vim
-- Note: You also have lazygit via Snacks (leader+gg)
return {
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
		cmd = { "Git", "G", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse", "GRemove", "GRename" },
	},
	{
		-- GitHub integration for vim-fugitive
		"tpope/vim-rhubarb",
		event = "VeryLazy",
		dependencies = { "tpope/vim-fugitive" },
	},
}
