return {
"Bekaboo/dropbar.nvim",
event = "VeryLazy",
dependencies = {
"nvim-telescope/telescope-fzf-native.nvim",
},
opts = {},
keys = {
{
"<leader>;",
function()
require("dropbar.api").pick()
end,
desc = "Pick Symbol (Dropbar)",
mode = "n",
},
{
"[;",
function()
require("dropbar.api").goto_context_start()
end,
desc = "Goto Context Start",
mode = "n",
},
-- Note: select_next_context SELECTS text (visual selection)
-- Instead, we'll just use pick() for navigation
{
"];",
function()
require("dropbar.api").pick()
end,
desc = "Pick Symbol (Navigate)",
mode = "n",
},
},
}
