return {
	"amrbashir/nvim-docs-view",
	cmd = "DocsViewToggle",
	opts = {
		position = "right",
		width = 70,
	},
	vim.keymap.set("n", "<leader>td", ":DocsViewToggle<CR>", { desc = "[T]oggle [D]ocs" }),
}
