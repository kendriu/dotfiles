return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	opts = {
		check_ts = true, -- Use treesitter
		ts_config = {
			lua = { "string" }, -- Don't add pairs in lua string treesitter nodes
			javascript = { "template_string" },
		},
		fast_wrap = {
			map = "<M-e>",
			chars = { "{", "[", "(", '"', "'" },
			pattern = [=[[%'%"%>%]%)%}%,]]=],
			end_key = "$",
			keys = "qwertyuiopzxcvbnmasdfghjkl",
			check_comma = true,
			highlight = "Search",
			highlight_grey = "Comment",
		},
	},
	config = function(_, opts)
		local npairs = require("nvim-autopairs")
		npairs.setup(opts)

		-- Integration with blink.cmp
		-- blink.cmp has built-in autopairs support, no manual integration needed
		-- The autopairs will work automatically in insert mode
	end,
}
