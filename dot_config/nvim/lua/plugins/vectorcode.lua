return {
	"Davidyz/VectorCode",
	dependencies = { "nvim-lua/plenary.nvim" },
	build = "uv tool upgrade vectorcode",
	cmd = "VectorCode", -- if you're lazy-loading VectorCode
}
