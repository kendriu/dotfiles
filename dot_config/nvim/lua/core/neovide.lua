if vim.g.neovide then
vim.o.guifont = "JetBrainsMono Nerd Font Mono:h13" -- Font setting
vim.g.neovide_hide_mouse_when_typing = true --  the mouse will be hidden as soon as you start typing
vim.g.neovide_cursor_animate_in_insert_mode = false -- If disabled, when in insert mode (mostly through i or a), the cursor will move like in other programs and immediately jump to its new position.
vim.g.neovide_cursor_vfx_mode = "torpedo"
end
