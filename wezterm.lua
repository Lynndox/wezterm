local wezterm = require("wezterm")
local config = wezterm.config_builder()

local tmux = require("tmux")

-- Plugins
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

config.colors = wezterm.color.load_scheme(wezterm.config_dir .. "/colors/tokyo-night-mod.toml")

config.initial_cols = 80
config.initial_rows = 24
config.font_size = 20

config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 2000 }

-- bar.apply_to_config(config)

tabline.setup({
	options = {
		icons_enabled = false,
		theme = config.colors,
		tabs_enabled = true,
		section_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
		component_separators = {
			left = wezterm.nerdfonts.pl_left_soft_divider,
			right = wezterm.nerdfonts.pl_right_soft_divider,
		},
		tab_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
	},
	sections = {
		tabline_a = { "mode" },
		tabline_b = {},
		tabline_c = {},
		tab_active = {
			"index",
			{ "process", max_length = 10 },
			-- { "parent", padding = 0 },
			-- "/",
			-- { "cwd", padding = { left = 0, right = 1 } },
			-- { "zoomed", padding = 0 },
		},
		tab_inactive = { "index", { "process", padding = { left = 0, right = 1 } } },
		tabline_x = {},
		tabline_y = {},
		tabline_z = { "domain" },
	},
	extensions = {},
})

tabline.apply_to_config(config)
tmux.apply_to_config(config, {})

return config
